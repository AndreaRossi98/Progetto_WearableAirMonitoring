#include <stdbool.h>        //PROGETTO_WEARABLE
#include <stdint.h>
#include <math.h>
#include "nrf.h"
#include "nrf_drv_timer.h"
#include "bsp.h"
#include "app_error.h"
#include "nrf_drv_saadc.h"
#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "nrf_log_default_backends.h"
#include "nrf_drv_twi.h"
#include "nrf_delay.h"
#include "nrf_nvmc.h"

//librerie per i sensori
#include "reading_sps30.h"
#include "reading_scd41.h"
#include "sps30.h"
#include "scd4x_i2c.h"
#include "bme280.h"
#include "bme280_defs.h"
#include "lis3dh_acc_driver.h"

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% CONSTANT DEFINITION %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
#define TWI_ADDRESSES   127         //Number of possible TWI addresses.
#define SAADC_BATTERY   0           //Canale tensione della batteria
#define TIMEOUT_VALUE   25   //1000       // 25 mseconds timer time-out value. Interrupt a 40Hz
#define START_ADDR  0x00011200      //indirizzo di partenza per salvataggio dati in memoria non volatile
#define LED             07

#define NO2_CHANNEL     0           //NO2 channel for ADC
#define CO_CHANNEL      2           //CO channel for ADC

#define _2_SEC          2       //interval of 2 seconds
#define _20_SEC         20      //interval of 20 seconds


//=============================================================================================================================================================================

struct data{
    uint8_t giorno;
    uint8_t mese;
    uint8_t anno;
};

struct val_campionati{
    float Temp;
    float Hum;
    float Pres;
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
//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% GLOBAL VARIABLE DEFINITION %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

int rtc_count = 0;
uint8_t flag_misurazioni = 0;
uint8_t misurazione_numero = 0;
float partial_calc = 0;        //variable to maintein partial calculation

nrf_saadc_value_t adc_val;  //variabile per campionamento 
ret_code_t err_code;        //variabile per valore di ritorno

//VARIABILI DEI SENSORI
struct bme280_dev           dev_bme280;         //struct for BME280
struct bme280_data          measure_bme280;     //struct for measured values by BME280
struct sps30_measurement    measure_sps30;      //struct for measured values by SPS30
struct lis3dh_data          measure_lis3dh;     //struct for measured values by LIS3DH
struct mics6814_data        measure_mics6814;   //struct for measured values by MICS6814
struct scd4x_data           measure_scd4x;     //struct for measured values by SCD41
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
       .scl                = 19,
       .sda                = 18,
       .frequency          = NRF_DRV_TWI_FREQ_100K,
       .interrupt_priority = APP_IRQ_PRIORITY_HIGH,
       .clear_bus_init     = false
    };

    err_code = nrf_drv_twi_init(&m_twi, &twi_config, NULL, NULL);
    APP_ERROR_CHECK(err_code);

    nrf_drv_twi_enable(&m_twi);
}
//=============================================================================================================================================================================

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
  %%%%%%%%%%%%%%%%%%%% LOG %%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
void log_init(void)
{
    APP_ERROR_CHECK(NRF_LOG_INIT(NULL));  // check if any error occurred during its initialization
    NRF_LOG_DEFAULT_BACKENDS_INIT();  // Initialize the log backends module
}
//=============================================================================================================================================================================

/*
*   Si può aggiungere funzione per lettura e scrittura
*   in memoria non volatile nrf_nvmc
*/

//=============================================================================================================================================================================
/*
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%% TIMER HANDLER %%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/
const nrfx_timer_t TIMER_LED = NRFX_TIMER_INSTANCE(0); // Timer 0 Enabled

void timer0_handler(nrf_timer_event_t event_type, void* p_context)
{

    switch(event_type)
    {
        case NRF_TIMER_EVENT_COMPARE0:
            rtc_count ++;
            //controllo della batteria, ogni quanto? come il campionamento, e come fare controllo? voltage divider?
            //err_code = nrf_drv_saadc_sample_convert(SAADC_BATTERY, &sample);   //lettura ADC
            //APP_ERROR_CHECK(err_code);

            //1 sec
            //Lettura dati VOC

            //2 sec
            if ((rtc_count % _2_SEC) == 0)
            {   
            nrf_gpio_pin_toggle(LED);
                //qua avrei invio valori con ant
                NRF_LOG_INFO("Invio valori con ANT");               
            }

            //20 sec
            if ((rtc_count % _20_SEC) == 0)
            {
                //campiono tutti i valori, flag e si fa nel main, confronto con umidità
                //rtc_count = 0 se non mi serve intervallo più grande
                flag_misurazioni = 1; //eseguire misurazioni ogni 20 sec nel main
                misurazione_numero ++;
            }
    
            //1 ora per sgp30 baseline iaq (capire se serve) 
            break;

        default:
            // Nothing
            break;
    
    }
}

void timer_init(void)
{
    uint32_t err_code = NRF_SUCCESS;
    uint32_t time_ms = 1000;        //DEFINISCE OGNI QUANTO SCATTA INTERRUPT DEL TIMER
    uint32_t time_ticks;  
    nrfx_timer_config_t timer_cfg = NRFX_TIMER_DEFAULT_CONFIG; // Configure the timer instance to default settings

    err_code = nrfx_timer_init(&TIMER_LED, &timer_cfg, timer0_handler); // Initialize the timer0 with default settings
    APP_ERROR_CHECK(err_code); // check if any error occured

    time_ticks = nrfx_timer_ms_to_ticks(&TIMER_LED, time_ms); // convert ms to ticks

    // Assign a channel, pass the number of ticks & enable interrupt
    nrfx_timer_extended_compare(&TIMER_LED, NRF_TIMER_CC_CHANNEL0, time_ticks, NRF_TIMER_SHORT_COMPARE0_CLEAR_MASK, true);
}

//=============================================================================================================================================================================

int main(void)
{
    nrf_gpio_cfg_output(LED);
    nrf_gpio_pin_set(LED);
    
    //Inizializzazione di tutte le componenti
    nrf_gpio_cfg_output(LED); // Initialize the pin
    nrf_gpio_pin_set(LED); // Turn off the LED
    log_init();
    saadc_init(); 
    twi_init();
printf("Inizio");
    NRF_LOG_INFO("Starting the program");    
    uint8_t sample_data;
    bool detected_device = false;

    //Scanning connected sensor
    for (uint8_t address = 1; address <= TWI_ADDRESSES; address++)
    {
        err_code = nrf_drv_twi_rx(&m_twi, address, &sample_data, sizeof(sample_data));
        if (err_code == NRF_SUCCESS)
        {
            detected_device = true;
            NRF_LOG_INFO("TWI device detected at address 0x%x.", address);
        }
        //NRF_LOG_FLUSH();
    }

    if (!detected_device)
    {
        NRF_LOG_INFO("No device was found.");
        NRF_LOG_FLUSH();
    }

    //Inizializzazione dei sensori

    sps30_init();
    NRF_LOG_INFO("SPS30 inizializzato");
    //scd41 non serve init
    bme280_init_set(&dev_bme280);
    NRF_LOG_INFO("BME280 inizializzato");
    lis3dh_init();
    NRF_LOG_INFO("Sensori inizializzati");

    //Inizializzazione del timer
    timer_init();
    nrfx_timer_enable(&TIMER_LED);

    while (1)
    {
        if(flag_misurazioni == 1)   //esegui tutte le misurazioni tranne VOC
        {
            float partial_calc = 0;        //variable to maintein partial calculation
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
            partial_calc = (5 - adc_to_volts(adc_val))/adc_to_volts(adc_val);
            measure_mics6814.NO2 = pow(10, (log10(partial_calc) -0.804)/(1.026))*1000;
            nrfx_saadc_sample_convert(CO_CHANNEL, &adc_val); //A3
            partial_calc = (5 - adc_to_volts(adc_val))/adc_to_volts(adc_val);
            measure_mics6814.CO = pow(10, (log10(partial_calc)-0.55)/(-0.85))*1000;      //controlla questa formula
            
            //BME280
            bme280_set_sensor_mode(BME280_FORCED_MODE, &dev_bme280);
            bme280_get_sensor_data(BME280_ALL, &measure_bme280, &dev_bme280);
    
            //LIS3DH    //scegliere ogni quanto campionare
            if(lis3dh_ReadAcc(&measure_lis3dh.AccX, &measure_lis3dh.AccY, &measure_lis3dh.AccZ) == true) 
            {
                measure_lis3dh.AccX = measure_lis3dh.AccX/256*16;
                measure_lis3dh.AccY = measure_lis3dh.AccY/256*16;
                measure_lis3dh.AccZ = measure_lis3dh.AccZ/256*16;
            }
            
            //SOLO IN QUESTA VERSIONE, STAMPO I RISULTATI OTTENUTI
            NRF_LOG_INFO("Misurazione %d° ", misurazione_numero);
            //BME280
            NRF_LOG_INFO("Temperatura [°C] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_bme280.temperature));
            NRF_LOG_INFO("Umidità [%%] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_bme280.humidity));
            NRF_LOG_INFO("Pressione [Pa] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_bme280.pressure));
            //SCD41
            NRF_LOG_INFO("CO2 [] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_scd4x.CO2));
            //SPS30
            NRF_LOG_INFO("PM 2.5 [µg/m³] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_sps30.mc_2p5));
            NRF_LOG_INFO("PM 1.0 [µg/m³] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_sps30.mc_1p0));
            //MICS6814
            NRF_LOG_INFO("NO2 [ppb] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_mics6814.NO2));
            NRF_LOG_INFO("CO [ppm] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_mics6814.CO));
            //SGP30
            NRF_LOG_INFO("VOC [ppb] = non presente");
            //LIS3DH
            NRF_LOG_INFO("ACC x [mg] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_lis3dh.AccX));
            NRF_LOG_INFO("ACC y [mg] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_lis3dh.AccY));
            NRF_LOG_INFO("ACC z [mg] =" NRF_LOG_FLOAT_MARKER"\r" ,NRF_LOG_FLOAT(measure_lis3dh.AccZ));

            flag_misurazioni = 0;         
        }

        //NRF_LOG_FLUSH();
        //nrf_pwr_mgmt_run();
        //__WFI();//GO INTO LOW POWER MODE
    }
}


/** @} */
