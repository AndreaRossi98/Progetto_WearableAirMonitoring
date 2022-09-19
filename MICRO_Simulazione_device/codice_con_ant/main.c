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
#define LED             10

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
void ant_send(uint8_t numero)
{
    uint8_t message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE];

    memset(message_payload, 0, ANT_STANDARD_DATA_PAYLOAD_SIZE);
    // Assign a new value to the broadcast data.
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 8] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 7] = numero; 
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 6] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 5] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 4] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 3] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 2] = numero;
    message_payload[ANT_STANDARD_DATA_PAYLOAD_SIZE - 1] = numero;

    // Broadcast the data.
    ret_code_t err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER,
                                                    ANT_STANDARD_DATA_PAYLOAD_SIZE,
                                                    message_payload);
    APP_ERROR_CHECK(err_code);
}
int prova = 0;
//Function for handling stack event
void ant_evt_handler(ant_evt_t * p_ant_evt, void * p_context)
{
    if (p_ant_evt->channel == BROADCAST_CHANNEL_NUMBER) 
    {
        switch (p_ant_evt->event)
        {
            case EVENT_RX:
            printf("pacchetto arrivato\n");
                if (p_ant_evt->message.ANT_MESSAGE_ucMesgID == MESG_BROADCAST_DATA_ID)
                {
printf("\nRicevuto: ");
for(int i = 0;i<8;i++)  printf("%d", p_ant_evt->message.ANT_MESSAGE_aucPayload [i]);
printf("\n");
                    

                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x01] == 0x04 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x03] == 0x04)
                    { //connesso a master, invia dati
                        
                        uint8_t  message_addr[ANT_STANDARD_DATA_PAYLOAD_SIZE];
                        for(int i = 0;i <8;i++)
                        {
                            message_addr[i] = 4;
                        }                        
                        printf("Saturation connesso\n");
                        err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, message_addr);
                        //ant_send(4);                           
                    }
                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x01] == 0x04 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x03] == 0x00)
                    { //connesso a master, invia dati
                        
                        uint8_t  message_addr[ANT_STANDARD_DATA_PAYLOAD_SIZE];
                        for(int i = 0;i <8;i++)
                        {
                            message_addr[i] = 4;
                        }                        
                        printf("Saturation dati\n");
                        err_code = sd_ant_broadcast_message_tx(BROADCAST_CHANNEL_NUMBER, ANT_STANDARD_DATA_PAYLOAD_SIZE, message_addr);
                        //ant_send(4);                           
                    }

                    if (p_ant_evt->message.ANT_MESSAGE_aucPayload [0x00] == 0x00 && p_ant_evt->message.ANT_MESSAGE_aucPayload [0x07] == 0x80 )
                    { 	//ferma l'acquisizione																				
                        sd_ant_pending_transmit_clear (BROADCAST_CHANNEL_NUMBER, NULL); //svuota il buffer, utile per una seconda acquisizione

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
        .channel_type      = CHANNEL_TYPE_SHARED_SLAVE,  //CHANNEL_TYPE_SHARED_SLAVE,     //
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

    //2 sec
    if ((rtc_count % _2_SEC) == 0 )  //non serve perchè invio gestito in ANT HANDLER
    {
        printf("\n2 sec\n");

    }

                                                                                       
}
//=============================================================================================================================================================================


int main(void)
{
printf("inizio simulazione invio\n"); 

    nrf_gpio_cfg_output(LED);
    nrf_gpio_pin_set(LED);

    //Inizializzazione di tutte le componenti
    log_init();

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


    // Main loop.
    for (;;)
    {
        nrf_pwr_mgmt_run();
        __WFI();//GO INTO LOW POWER MODE
    }
}


/**
 *@}
 **/