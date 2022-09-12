#include <stdbool.h>        //%%%%%%%%%%%%%%____MIA PROVA___%%%%%%%%
#include <stdint.h>
#include <string.h>
#include "nrf.h"
#include "bsp.h"
#include "hardfault.h"
#include "app_error.h"
#include "app_timer.h"
#include "nrf_sdh.h"
#include "nrf_sdh_ant.h"
#include "nrf_pwr_mgmt.h"
#include "ant_interface.h"
#include "ant_parameters.h"
#include "ant_channel_config.h"

#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "nrf_log_default_backends.h"

#include "nrf_delay.h"
#include "nrf_gpio.h" //potrebbe non servire
#include "nrf_drv_saadc.h"
//#include "nrf_drv_clock.h" //da qualche errore, rimosso il .c (da lucchesini posso comunque commentarlo e non da errore)
#include "nrf_nvmc.h"
#include "app_timer.h"

#include "nrf_drv_twi.h"
//includere tutte le librerie per i sensori
#include "sps30.h"
#include "scd4x_i2c.h"
#include "bme280.h"
#include "lis3dh_acc_driver.h"
#include "sgp30.h"
#include <math.h>
//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% CONSTANT DEFINITION %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
#define TWI_ADDRESSES   127         //Number of possible TWI addresses.
#define APP_ANT_OBSERVER_PRIO   1   // Application's ANT observer priority. You shouldn't need to modify this value.
#define SAADC_BATTERY   0           //Canale tensione della batteria
#define TIMEOUT_VALUE   1000   //1000       //interrupt timer a 1 sec
#define START_ADDR  0x00011200      //indirizzo di partenza per salvataggio dati in memoria non volatile
#define LED             10  //07

#define NO2_CHANNEL     0           //NO2 channel for ADC
#define CO_CHANNEL      2           //CO channel for ADC

#define _2_SEC          2       //interval of 2 seconds
#define _20_SEC         20      //interval of 20 seconds

#define ENVIR_MONITOR_DEVICE    6   
//=============================================================================================================================================================================

struct data{
    uint8_t giorno;
    uint8_t mese;
    uint8_t anno;
};

struct val_campionati{
    float Temp;
    float Hum;
    double Pres;    //Attenzione dimensioni variabile
    float PM1p0;    //controlla che sia corretto, scegliere quali valori guardare di PM
    float PM2p5;
    float CO2;
    float CO;
    float NO2;
    float VOC;
};

struct mics6814_data{
    uint16_t NO2;
    uint16_t CO;
};

struct scd4x_data{
    uint16_t CO2;
    int32_t Temperature;
    int32_t Humidity;
};

struct sgp30_data{
    uint16_t tVOC;
    uint16_t CO2_eq;
};
//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% GLOBAL VARIABLE DEFINITION %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
int i = 0;
uint8_t notshown = 1;           // per il log

int rtc_count = 0;
//queste due variabili servono per gestire i sensori: se flag misurazione 1 e connesso 1 allora misuro ogni 20 sec, aggiorno e invio
uint8_t flag_misurazioni = 0;
uint8_t connesso = 0;           // = 1 indica che il master si è connesso e sta chiedendo i dati letti
float partial_calc = 0;        //variable to maintein partial calculation

//variabili per la gestione di ANT
uint8_t message_addr[8] = {6,6,6,6,6,6,6,6};
uint8_t pacchetto_1[8] = {0,0,0,0,0,0,0,0};  //pacchetti che contengono i valori campionati
uint8_t pacchetto_2[8] = {0,0,0,0,0,0,0,0};  //ed elaborati per poter essere inviati tramite ANT
uint8_t pacchetto_3[8] = {0,0,0,0,0,0,0,0};  //senza problemi di formato (uint8_t

uint8_t pacchetto_1_inviare[8] = {0,0,0,0,0,0,0,0}; //pacchetti che contengono i valori campionati ed elaborati
uint8_t pacchetto_2_inviare[8] = {0,0,0,0,0,0,0,0}; //pronti ad essere inviati
uint8_t pacchetto_3_inviare[8] = {0,0,0,0,0,0,0,0}; //divisi in modo tale che non c'è il rischio di modifiche durante l'invio

uint8_t pacchetto_P = 1;   //serve a selezionare il pacchetto da inviare tra P1 P2 P3
uint8_t numero_pacchetto = 1;   //numero incrementale del pacchetto che si invia (da 1 a 63, 6 bit)

uint8_t pacchetto = 0;

nrf_saadc_value_t adc_val;  //variabile per campionamento 
ret_code_t err_code;        //variabile per valore di ritorno

uint8_t flag_inizializzazione = 0;  //flag che definisce inizializzazione dei sensori in corso
uint8_t flag_dati_pronti = 0; //flag che dice che non ci sono ancora dei dati da inviare
uint8_t valore = 0;

//VARIABILI DEI SENSORI
struct bme280_dev           dev_bme280;         //struct for BME280
struct bme280_data          measure_bme280;     //struct for measured values by BME280
struct sps30_measurement    measure_sps30;      //struct for measured values by SPS30
struct lis3dh_data          measure_lis3dh;     //struct for measured values by LIS3DH
struct mics6814_data        measure_mics6814;   //struct for measured values by MICS6814
struct scd4x_data           measure_scd4x;      //struct for measured values by SCD41
struct sgp30_data           measure_sgp30;      //struct for measured values by SGP30
//=============================================================================================================================================================================

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% TWI COMMUNICATION %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
//TWI instance ID.
#if TWI0_ENABLED
#define TWI_INSTANCE_ID     0
#elif TWI1_ENABLED
#define TWI_INSTANCE_ID     1
#endif

//TWI instance
static const nrf_drv_twi_t m_twi = NRF_DRV_TWI_INSTANCE(TWI_INSTANCE_ID);

//TWI initialization
void twi_init (void)
{
    ret_code_t err_code;
    const nrf_drv_twi_config_t twi_config = {
       .scl                = 6, //19,  //6
       .sda                = 8, //18,  //8  
       .frequency          = NRF_DRV_TWI_FREQ_100K,
       .interrupt_priority = APP_IRQ_PRIORITY_HIGH,
       .clear_bus_init     = false
    };

    err_code = nrf_drv_twi_init(&m_twi, &twi_config, NULL, NULL);
    APP_ERROR_CHECK(err_code);

    nrf_drv_twi_enable(&m_twi);
}
//=============================================================================================================================================================================

APP_TIMER_DEF(m_repeated_timer_id);     /*Handler for repeated timer */

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% SAADC %%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
void saadc_callback(nrf_drv_saadc_evt_t const * p_event)  //non serve
{
}

void saadc_init(void)   //prova a mettere low power mode
{
    ret_code_t err_code;
    nrf_saadc_channel_config_t channel1_config = NRF_DRV_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN1);
    nrf_saadc_channel_config_t channel3_config = NRF_DRV_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN3);

    err_code = nrf_drv_saadc_init(NULL, saadc_callback);
    APP_ERROR_CHECK(err_code);

    err_code = nrf_drv_saadc_channel_init(NO2_CHANNEL, &channel1_config);
    APP_ERROR_CHECK(err_code);
	
    err_code = nrf_drv_saadc_channel_init(CO_CHANNEL, &channel3_config);
    APP_ERROR_CHECK(err_code); 
}
//Transform the ADC value in bit in voltage value
float adc_to_volts (int adc)
{
    float volts = (adc + 5) * 3.6 / 1023;
    return volts;
}
//=============================================================================================================================================================================

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
static void log_init(void)
{
    ret_code_t err_code = NRF_LOG_INIT(NULL);
    APP_ERROR_CHECK(err_code);

    NRF_LOG_DEFAULT_BACKENDS_INIT();
}

static void utils_setup(void)
{
    ret_code_t err_code = app_timer_init();
    APP_ERROR_CHECK(err_code);

    err_code = bsp_init(BSP_INIT_LEDS,
                        NULL);
    APP_ERROR_CHECK(err_code);

    err_code = nrf_pwr_mgmt_init();
    APP_ERROR_CHECK(err_code);
}
//=============================================================================================================================================================================

/*
*   Si può aggiungere funzione per lettura e scrittura
*   in memoria non volatile nrf_nvmc
*/

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% ANT COMMUNICATION %%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
void ant_send(uint8_t numero_pacchetto, int counter, int quat1, int quat2, int quat3, float quat4)
{
    uint8_t message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE];

    memset(message_payload, 0, ANT_STANDARD_DATA_PAYLOAD_SIZE);
    // Assign a new value to the broadcast data.
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 8] = 6; //DEVICENUMBER
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 7] = numero_pacchetto; 
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 6] = 0;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 5] = counter;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 4] = quat1;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 3] = quat2;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 2] = quat3;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 1] = quat4;

    // Broadcast the data.
    ret_code_t err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER,
                                                    ANT_STANDARD_DATA_PAYLOAD_SIZE,
                                                    message_payload);
    APP_ERROR_CHECK(err_code);
    NRF_LOG_INFO("Messaggio numero %d, ret code ant broadcast: %d", counter, err_code);
}

//Function for handling stack event
void ant_evt_handler(ant_evt_t * p_ant_evt, void * p_context)
{
    if (p_ant_evt->channel == BROADCAST_CHANNEL_NUMBER && flag_inizializzazione == 1)  //durante l'inizializzazione dei sensori ignora tutti i messaggi che arrivano dal master
    {
        switch (p_ant_evt->event)
        {
            case EVENT_RX:
                if (p_ant_evt->message.ANT_MESSAGE_ucMesgID == MESG_BROADCAST_DATA_ID)
                {
printf("\nRicevuto: ");
for(int i = 0;i<8;i++)  printf("%d", p_ant_evt->message.ANT_MESSAGE_aucPayload [i]);
printf("\n");

                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x00] == 0x06 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x07] == 0x06 );
                    { //richiesta di connessione da parte del master
                        uint8_t  message_addr[ANT_STANDARD_DATA_PAYLOAD_SIZE];
                        memset(message_addr, 6, ANT_STANDARD_DATA_PAYLOAD_SIZE);	
                        err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, message_addr); //invia messaggio di connessione
                        NRF_LOG_INFO("Ricevuto messaggio di connessione");
                    }
                    
                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x00] == 0x06 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x07] == 0x00)
                    { //connesso a master, invia dati
                        
                        sd_ant_pending_transmit_clear (BROADCAST_CHANNEL_NUMBER, NULL); //svuota il buffer, utile per una seconda acquisizione
                        connesso = 1;
//aggiungere gestione del pacchetto da inviare 1 2 3

//se i dati non sono ancora pronti (caso di accensione), invio un pacchetto standard es 6,6,6,6,6,6,6,6,6
//se no invio in ordine sequenziale pacchetto 1, pacchetto 2, pacchetto 3

//fare controllo che dati siano pronti    
                        if (flag_dati_pronti == 0)
//invio pacchetto standard                    
                            err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, message_addr);

//se no gestisco i tre pacchetti          
                        else
                        {   //aggiungi stampa del pacchetto inviato per vedere che funzioni correttamente
                              if (pacchetto_P == 1)
                              {   //invio pacchetto 1
                                  err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, pacchetto_1_inviare);
printf("Invio P1: ");
for(int i = 0;i<8;i++)  printf("%d ", pacchetto_1_inviare[i]);
printf("\n");
                              }
                              else if (pacchetto_P == 2)
                              {
                                  err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, pacchetto_2_inviare);
printf("Invio P2: ");
for(int i = 0;i<8;i++)  printf("%d ", pacchetto_2_inviare[i]);
printf("\n");
                              }
                              else if (pacchetto_P == 3)
                              {
                                  err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, pacchetto_3_inviare);
printf("Invio P3: ");
for(int i = 0;i<8;i++)  printf("%d ", pacchetto_3_inviare[i]);
printf("\n");
                              }

                              pacchetto_P++;

                            if (flag_misurazioni == 2 && pacchetto_P == 4) //aggiorno i pacchetti da inviare. Farlo dopo che ho inviato lo stesso numero di pacchetti per ogni pacchetto??
                            {
                                for (int i = 0; i < 8 ; i++)
                                {
                                    pacchetto_1_inviare[i] = pacchetto_1[i];
                                    pacchetto_2_inviare[i] = pacchetto_2[i];
                                    pacchetto_3_inviare[i] = pacchetto_3[i];
                                }
                                flag_misurazioni = 0;                      
                            } //pacchetti da inviare aggiornati, i prossimi da inviare sono aggiornati
                            if (pacchetto_P == 4)
                                pacchetto_P = 1; //riparto ad inviare il primo pacchetto
                        }
                    }

                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x00] == 0x00 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x07] == 0x80 )
                    { 	//ferma l'acquisizione																				
                        sd_ant_pending_transmit_clear (BROADCAST_CHANNEL_NUMBER, NULL); //svuota il buffer, utile per una seconda acquisizione
                        connesso = 0;
                        pacchetto_P = 0;
                        flag_misurazioni = 0;
                        flag_dati_pronti = 0;

                    }
                       
                }
                break;

            case EVENT_RX_SEARCH_TIMEOUT:	   //in caso di timeout riapre il canale
                err_code = sd_ant_channel_open(BROADCAST_CHANNEL_NUMBER);
                APP_ERROR_CHECK(err_code); 
                break;							

            default:
                break;
        }
    }
}

NRF_SDH_ANT_OBSERVER(m_ant_observer, APP_ANT_OBSERVER_PRIO, ant_evt_handler, NULL);

//Function for ANT stack initialization.
static void softdevice_setup(void)
{
    ret_code_t err_code = nrf_sdh_enable_request();
    APP_ERROR_CHECK(err_code);

    ASSERT(nrf_sdh_is_enabled());

    err_code = nrf_sdh_ant_enable();
    APP_ERROR_CHECK(err_code);
}

// Function for setting up the ANT module to be ready for RX broadcast.
static void ant_channel_rx_broadcast_setup(void)
{
    ant_channel_config_t broadcast_channel_config =
    {
        .channel_number    = BROADCAST_CHANNEL_NUMBER,
        .channel_type      = CHANNEL_TYPE_SLAVE,     //CHANNEL_TYPE_SLAVE,
        .ext_assign        = 0x00,
        .rf_freq           = RF_FREQ,
        .transmission_type = CHAN_ID_TRANS_TYPE,
        .device_type       = CHAN_ID_DEV_TYPE,
        .device_number     = CHAN_ID_DEV_NUM,
        .channel_period    = CHAN_PERIOD,
        .network_number    = ANT_NETWORK_NUM,
    };

    ret_code_t err_code = ant_channel_init(&broadcast_channel_config);
    APP_ERROR_CHECK(err_code);

    // Open channel.
    err_code = sd_ant_channel_open(BROADCAST_CHANNEL_NUMBER);
    APP_ERROR_CHECK(err_code);
}
//=============================================================================================================================================================================

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% TIMER HANDLER %%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
int VOC = 0;
int count_VOC = 0;
static void repeated_timer_handler(void * p_context)  //app timer, faccio scattare ogni un secondo
{ 
    rtc_count ++;
    nrf_gpio_pin_toggle(LED);
    //controllo della batteria, ogni quanto? come il campionamento, e come fare controllo? voltage divider?
    //err_code = nrf_drv_saadc_sample_convert(SAADC_BATTERY, &sample);   //lettura ADC
    //APP_ERROR_CHECK(err_code);

    //1 sec
    sgp30_measure_iaq_blocking_read(&measure_sgp30.tVOC, &measure_sgp30.CO2_eq);
    VOC = VOC + measure_sgp30.tVOC;
    count_VOC ++;
    printf("VOC %d\n", VOC);
    //2 sec
    if ((rtc_count % _2_SEC) == 0 )  //non serve perchè invio gestito in ANT HANDLER
    {
        printf("\n2 sec\n");

    }
//simulo un aggiornamento dei valori ogni 6 secondi, così invio ogni pacchetto 2 volte
/*if((rtc_count % 12) == 0)
{
    flag_misurazioni = 1; //non andrebbe qua, ma nei 20 sec
}*/
    //20 sec
    if ((rtc_count % _20_SEC) == 0)
    {
        //campiono tutti i valori, flag e si fa nel main, confronto con umidità
        rtc_count = 0;  // se non mi serve intervallo più grande
        flag_misurazioni = 1; //eseguire misurazioni ogni 20 sec nel main
    }
    
    if ((rtc_count % 30) == 0)
    {
        VOC = 0;
        count_VOC =0;
    }

    //1 ora per sgp30 baseline iaq (capire se serve)                                                                                     
}
//=============================================================================================================================================================================


int main(void)
{
printf("inizio\n"); 

    nrf_gpio_cfg_output(LED);
    nrf_gpio_pin_set(LED);

    //Inizializzazione di tutte le componenti
    log_init();
    saadc_init();
    twi_init();
printf("Start\n");
    softdevice_setup();
    ant_channel_rx_broadcast_setup();
    utils_setup();

    sd_ant_channel_radio_tx_power_set(BROADCAST_CHANNEL_NUMBER, RADIO_TX_POWER_LVL_4, NULL); 	//potenza trasmissione
    
    app_timer_init();
    err_code = app_timer_create(&m_repeated_timer_id,
                            APP_TIMER_MODE_REPEATED,
                            repeated_timer_handler);
    APP_ERROR_CHECK(err_code);

    nrf_gpio_pin_clear(LED);
    err_code = nrf_pwr_mgmt_init();
    APP_ERROR_CHECK(err_code);
printf("Timer\n");    
    err_code = app_timer_start(m_repeated_timer_id, APP_TIMER_TICKS(TIMEOUT_VALUE), NULL);
    APP_ERROR_CHECK(err_code);	

    /* 
     * Inizializzazione dei sensori
     */
    if(flag_inizializzazione == 0)
    {
        err_code = 1;
//        while (err_code != 0)
            err_code = sps30_init();   //tutto ok ritorna 0
        err_code = 1;
//        while (err_code = !0)
             err_code = bme280_init_set(&dev_bme280); //tutto ok ritorna 0
        //scd41 non serve init
        err_code = 1;
//        while (err_code = !0)
            
        //SGP30
        err_code = sgp30_init();
        printf("\nSGP30 inizializzato\n\n");
        sgp30_iaq_init();

            err_code = lis3dh_init();    //tutto ok ritorna 0
printf("Sensori correttamente inizializzati\n");
        flag_inizializzazione = 1;
    }

    /*
     * Pulizia ventola ad ogni accensione 
     */


//valore di prova per simulare valori inviati
//da eliminare poi
 uint8_t valore_prova = 0;

    // Main loop.
    for (;;)
    {
        if(flag_misurazioni == 1 && connesso == 1)   //esegui tutte le misurazioni tranne VOC
        {
            
            float partial_calc = 0;        //variable to maintein partial calculation
            int calcolo_parziale = 0;
//ha senso guardare se restituiscono o meno errore queste funzioni?
            
            //unire sps e scd per fare un unico delay, o separarli per consumo di corrente massimo disponibile
            
            //SPS30 
            sps30_wake_up();
            sps30_start_measurement();
            nrf_delay_ms(1000);
            sps30_read_measurement(&measure_sps30);
            sps30_stop_measurement();
            sps30_sleep();

            //SCD41
            scd4x_wake_up();
            scd4x_measure_single_shot();
            nrf_delay_ms(100);
            scd4x_read_measurement(&measure_scd4x.CO2, &measure_scd4x.Temperature, &measure_scd4x.Humidity);
            scd4x_power_down();

            //MICS6814
            nrfx_saadc_sample_convert(NO2_CHANNEL, &adc_val); //A1
            //partial_calc = (5 - adc_to_volts(adc_val))/adc_to_volts(adc_val);
            //measure_mics6814.NO2 = pow(10, (log10(partial_calc) -0.804)/(1.026))*1000;
            measure_mics6814.NO2 = adc_val;
            nrfx_saadc_sample_convert(CO_CHANNEL, &adc_val); //A3
            //partial_calc = (5 - adc_to_volts(adc_val))/adc_to_volts(adc_val);
            //measure_mics6814.CO = pow(10, (log10(partial_calc)-0.55)/(-0.85));
            measure_mics6814.CO = adc_val;
            
            //BME280
            bme280_set_sensor_mode(BME280_FORCED_MODE, &dev_bme280);
            bme280_get_sensor_data(BME280_ALL, &measure_bme280, &dev_bme280);


            //LIS3DH
            //scegliere ogni quanto campionare   
//simulazione di dati letti e pronti da inviare al device   

printf("\nMisuro\n");

          //letti tutti i valori, elaboro i dati in modo da poterli inviare come uint8 e li salvo nei pacchetti, poi metto flag_misurazione = 2 e la gestisco in ANT
/*//Valori simulati          
          pacchetto_1[0] = 64 + numero_pacchetto;
          pacchetto_1[1] = valore_prova; //Temperatura
          pacchetto_1[2] = valore_prova; //Temperatura
          pacchetto_1[3] = valore_prova; //Umidità
          pacchetto_1[4] = valore_prova; //Umidità
          pacchetto_1[5] = valore_prova; //Pressione
          pacchetto_1[6] = valore_prova; //Pressione
          pacchetto_1[7] = valore_prova; //Pressione
          */
//valori veri

          pacchetto_1[0] = 64 + numero_pacchetto;
          pacchetto_1[1] = (int) measure_bme280.temperature + 30;    //Parte intera della Temperatura incrementato di 30 (o più?)
          pacchetto_1[2] = abs((int)((measure_bme280.temperature - (int)measure_bme280.temperature)*100));  //parte decimale della Temperatura
          pacchetto_1[3] = (int) measure_bme280.humidity;
          pacchetto_1[4] = (int)((measure_bme280.humidity - (int)measure_bme280.humidity)*100);
          calcolo_parziale = measure_bme280.pressure;
          pacchetto_1[5] = calcolo_parziale >> 16; //Pressione  >> 16
          pacchetto_1[6] = calcolo_parziale >> 8; //Pressione  >> 8
          pacchetto_1[7] = calcolo_parziale; //Pressione

/*
//Valori simulati          
          pacchetto_2[0] = 128 + numero_pacchetto;
          pacchetto_2[1] = valore_prova+1; //VOC      
          pacchetto_2[2] = valore_prova+1; //VOC      
          pacchetto_2[3] = valore_prova+1; //CO2
          pacchetto_2[4] = valore_prova+1; //CO2
          pacchetto_2[5] = valore_prova+1; //NO2
          pacchetto_2[6] = valore_prova+1; //NO2
          pacchetto_2[7] = valore_prova+1; //CO
*/
//Valori veri
          calcolo_parziale = (int)(VOC/count_VOC);
          count_VOC = 0;
          pacchetto_2[0] = 128 + numero_pacchetto;
          pacchetto_2[1] = calcolo_parziale; //VOC  LSB (least significant Byte)      
          pacchetto_2[2] = calcolo_parziale >> 8; //VOC  MSB (Most significant Byte)     
          pacchetto_2[3] = measure_scd4x.CO2; //CO2  LSB (least significant Byte)   //dovrebbe bastare così
          pacchetto_2[4] = measure_scd4x.CO2 >> 8; //CO2  MSB (Most significant Byte)
          pacchetto_2[5] = measure_mics6814.NO2; //NO2
          pacchetto_2[6] = measure_mics6814.CO; //CO
          pacchetto_2[7] = 123; // BATTERY   capire ogni quanto campionare
/*
//valori simulati
          pacchetto_3[0] = 192 + numero_pacchetto;
          pacchetto_3[1] = valore_prova+1; //VOC      
          pacchetto_3[2] = valore_prova+1; //VOC      
          pacchetto_3[3] = valore_prova+1; //CO2
          pacchetto_3[4] = valore_prova+1; //CO2
          pacchetto_3[5] = valore_prova+1; //NO2
          pacchetto_3[6] = valore_prova+1; //NO2
          pacchetto_3[7] = valore_prova+1; //CO
*/
//valori veri
          
          pacchetto_3[0] = 192 + numero_pacchetto;
          pacchetto_3[1] = 10; //ACCELERATION   capire ogni quanto leggere il dato
          pacchetto_3[2] = (int)(measure_sps30.mc_1p0 * 10); //PM1.0 LSB        PM valori moltiplicati per 10
          pacchetto_3[3] = (int)(measure_sps30.mc_1p0 * 10) >> 8; //PM1.0  MSB
          pacchetto_3[4] = (int)(measure_sps30.mc_2p5 * 10); //PM2.5  LSB
          pacchetto_3[5] = (int)(measure_sps30.mc_2p5 * 10) >> 8; //PM2.5  MSB
          pacchetto_3[6] = (int)(measure_sps30.mc_10p0 * 10); //PM10   LSB
          pacchetto_3[7] = (int)(measure_sps30.mc_10p0 * 10) >> 8; //PM10   MSB


//finiti di mettere i valori negli array, incremento il valore di numero_pacchetto.
// se supera 63 (6 bit), lo riporto a 1

        numero_pacchetto++;
        if (numero_pacchetto == 64)
          numero_pacchetto = 1;

valore_prova = valore_prova +10;
          flag_misurazioni = 2;
printf("DATI PRONTI PER ESSERE INVIATI\n");
          if (flag_dati_pronti == 0){ //problema è che ho dati pronti ma non si sono aggiornati i pacchetti da inviare
              //primo aggiornamento lo faccio io qua
              for (int i = 0; i < 8 ; i++)
                  {
                      pacchetto_1_inviare[i] = pacchetto_1[i];
                      pacchetto_2_inviare[i] = pacchetto_2[i];
                      pacchetto_3_inviare[i] = pacchetto_3[i];
                  }  
              flag_dati_pronti = 1;
          }


        }

        nrf_pwr_mgmt_run();
        __WFI();//GO INTO LOW POWER MODE
    }
}


/**
 *@}
 **/