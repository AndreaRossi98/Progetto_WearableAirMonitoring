#include <stdbool.h>
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

//librerie per i sensori
#include "reading_sps30.h"
#include "reading_scd41.h"
#include "sps30.h"
#include "scd4x_i2c.h"
#include "bme280.h"
#include "bme280_defs.h"


#define LED1 07
uint32_t count = 0;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //////TWI PART/////
                        ///////////////////
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

//Number of possible TWI addresses.
#define TWI_ADDRESSES      127
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //////SAADC PART/////
                        /////////////////////

void saadc_callback_handler(nrf_drv_saadc_evt_t const * p_event)
{
}

void saadc_init(void)
{
    ret_code_t err_code;
    // Create a config struct and assign it default values along with the Pin number for ADC Input.
    nrf_saadc_channel_config_t channel0_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN1);
    nrf_saadc_channel_config_t channel1_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN2);
    nrf_saadc_channel_config_t channel2_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN3);
    //channel2_config.gain = 1;
    //channel1_config.gain = 1;
    //channel0_config.gain = 1;

    // Initialize the saadc 
    err_code = nrf_drv_saadc_init(NULL, saadc_callback_handler);
    APP_ERROR_CHECK(err_code);

    // Initialize the Channel which will be connected to that specific pin.
    err_code = nrfx_saadc_channel_init(0, &channel0_config);    //A1
    APP_ERROR_CHECK(err_code);
    err_code = nrfx_saadc_channel_init(1, &channel1_config);    //A2
    APP_ERROR_CHECK(err_code);
    err_code = nrfx_saadc_channel_init(2, &channel2_config);    //A3
    APP_ERROR_CHECK(err_code);
}

nrf_saadc_value_t adc_val;      //variable to hold the value read by the ADC

float ADC_TO_VOLTS (int adc)
{
    float volts = (adc + 5) * 3.6 / 1023;
    return volts;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //////LOG PART/////
                        ///////////////////
void log_init(void)
{
    APP_ERROR_CHECK(NRF_LOG_INIT(NULL));  // check if any error occurred during its initialization
    NRF_LOG_DEFAULT_BACKENDS_INIT();  // Initialize the log backends module
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //////TIMER PART/////
                        /////////////////////

const nrfx_timer_t TIMER_LED = NRFX_TIMER_INSTANCE(0); // Timer 0 Enabled
struct bme280_dev dev;
void timer0_handler(nrf_timer_event_t event_type, void* p_context)
{
int16_t error = 0;
int16_t ret;
uint16_t status;
struct sps30_measurement measurement;
int16_t intero;
int16_t decimale;
    switch(event_type)
    {
        case NRF_TIMER_EVENT_COMPARE0:
            count++;
            nrf_gpio_pin_toggle(LED1);
            printf("%d\n\r", count);

            ret = sps30_read_measurement(&measurement);
            if(ret < 0)
            {
                printf("read measurement failed\n\r");
            }
            else
            {
                intero = measurement.mc_2p5;
                decimale = (measurement.mc_2p5 - intero)*100;
                printf("PM 2.5: %d.%d [µg/m³]\n\r", intero, decimale);
            }

            bool data_ready_flag = false;
            nrf_delay_ms(5000);
            error = scd4x_get_data_ready_flag(&data_ready_flag);
            if (error) 
            {
                printf("Error executing scd4x_get_data_ready_flag(): %i\n", error);
                //continue;
            }
            if (!data_ready_flag) 
            {
                //nrf_delay_ms(500);
                printf("sono qua  \n");
                //continue;
            }
        
            uint16_t co2;
            int32_t temperature;
            int32_t humidity;
            error = scd4x_read_measurement(&co2, &temperature, &humidity);
            if (error) 
            {
                printf("Error executing scd4x_read_measurement(): %i\n", error);
            } 
            else if (co2 == 0) 
            {
                printf("Invalid sample detected, skipping.\n");
            } 
            else 
            {
                printf("CO2: %u ppm\n", co2);
                printf("Temperature: %d m°C\n", temperature);
                printf("Humidity: %d mRH\n", humidity);
            }

            float value = 0;
            nrfx_saadc_sample_convert(0, &adc_val); //A1
            value = (5 - ADC_TO_VOLTS(adc_val))/ADC_TO_VOLTS(adc_val);      //Rs/Rl
            value = pow(10, (log10(value)-0.804)/1.026)*1000;
            intero = value;      
            printf("NO2: %d [ppb]\n", adc_val);

            nrfx_saadc_sample_convert(1, &adc_val); //A2
            value = (5 - ADC_TO_VOLTS(adc_val))/ADC_TO_VOLTS(adc_val);      //Rs/Rl
            value = pow(10, (log10(value)+0.104)/(-0.538));
            intero = value;
            printf("NH3: %d [ppm]\n", intero);

            nrfx_saadc_sample_convert(2, &adc_val); //A3
            value = (5 - ADC_TO_VOLTS(adc_val))/ADC_TO_VOLTS(adc_val);      //Rs/Rl
            value = pow(10, (log10(value)-0.55)/-0.85)*1000;
            intero = value;
            printf("CO:  %d [ppm]\n", intero);

struct bme280_data comp_data;
error = bme280_get_sensor_data(BME280_ALL, &comp_data, &dev);
    int intero;
    int decimale;
    intero = comp_data.temperature;
    decimale = (comp_data.temperature - intero) * 100;
    printf("T [°C] : %d.%d\n", intero, decimale);

    intero = comp_data.humidity;
    decimale = (comp_data.humidity - intero) * 100;
    printf("RH [%%]: %d.%d\n",intero, decimale);

    intero = comp_data.pressure;
    decimale = (comp_data.pressure - intero) * 100;
    printf("P [Pa]: %d.%d\n", intero, decimale);
            printf("\n");
            break;

        default:
            // Nothing
            break;
    
    }
}

void timer_init(void)
{
    uint32_t err_code = NRF_SUCCESS;
    uint32_t time_ms = 10000;        //DEFINISCE OGNI QUANTO SCATTA INTERRUPT DEL TIMER
    uint32_t time_ticks;  
    nrfx_timer_config_t timer_cfg = NRFX_TIMER_DEFAULT_CONFIG; // Configure the timer instance to default settings

    err_code = nrfx_timer_init(&TIMER_LED, &timer_cfg, timer0_handler); // Initialize the timer0 with default settings
    APP_ERROR_CHECK(err_code); // check if any error occured

    time_ticks = nrfx_timer_ms_to_ticks(&TIMER_LED, time_ms); // convert ms to ticks

    // Assign a channel, pass the number of ticks & enable interrupt
    nrfx_timer_extended_compare(&TIMER_LED, NRF_TIMER_CC_CHANNEL0, time_ticks, NRF_TIMER_SHORT_COMPARE0_CLEAR_MASK, true);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



int main(void)
{
    ret_code_t err_code;
    uint8_t address;
    uint8_t sample_data;
    bool detected_device = false;
    nrf_gpio_cfg_output(LED1); // Initialize the pin
    nrf_gpio_pin_set(LED1); // Turn off the LED
    log_init();
    saadc_init(); 
    
    twi_init();

    NRF_LOG_INFO("Starting the program");    

//////////////////////////////////////
///SCANNING OF CONNECTED SENSORS//////
//////////////////////////////////////   
    for (address = 1; address <= TWI_ADDRESSES; address++)
    {
        err_code = nrf_drv_twi_rx(&m_twi, address, &sample_data, sizeof(sample_data));
        if (err_code == NRF_SUCCESS)
        {
            detected_device = true;
            NRF_LOG_INFO("TWI device detected at address 0x%x.", address);
        }
        NRF_LOG_FLUSH();
    }

    if (!detected_device)
    {
        NRF_LOG_INFO("No device was found.");
        NRF_LOG_FLUSH();
    }
    
    

///////////////////////////////
///SENSORS'S INITIALIZATION////
///////////////////////////////
//funzione di ricalibrazione dell'offset
/*
static bool                    m_saadc_calibrate = false;
if(m_saadc_calibrate == true)
{
nrf_drv_saadc_abort();                                  // Abort all ongoing conversions. Calibration cannot be run if SAADC is busy
NRF_LOG_INFO("SAADC calibration starting...");    //Print on UART

while(nrf_drv_saadc_calibrate_offset() != NRF_SUCCESS); //Trigger calibration task
m_saadc_calibrate = false;
}
*/
    //lettura_scd41(3);
    //lettura_sps30(1);

    int16_t error = 0;
    uint16_t status;
    uint16_t target_co2_concentration;
    uint16_t* frc_correction;

    target_co2_concentration = 400;

    scd4x_wake_up();
    scd4x_stop_periodic_measurement();
    //nrf_delay_ms(500);  //dopo stop aspettare almeno 500 ms
    scd4x_reinit();       //sembra non servire, non ho ancora modificato alcun parametro
    nrf_delay_ms(1000);
    
    error = scd4x_start_periodic_measurement();
    //error = scd4x_start_low_power_periodic_measurement();
    //nrf_delay_ms(1000);

    if(error != 0)  printf("errore\n");
    else    printf("Periodic scd41 measurement started\n\n");



    struct sps30_measurement measurement;
    int16_t ret;
    uint8_t data[10][4];
    #define SPS_CMD_READ_MEASUREMENT 0x0300
  
    //sps30_stop_measurement(); //provato ad aggiungere per vedere se risolve problema del probe failed ripetuto
/*    
    //check if the sensor is ready to start and initialize it
    while (sps30_probe() != 0) 
    {
        printf("probe failed\n\r");
        nrf_delay_ms(1000);
    }
    printf("probe succeeded\n\r");
*/
    //start measurement and wait for 10s to ensure the sensor has a
    //stable flow and possible remaining particles are cleaned out
    if (sps30_start_measurement() != 0) 
    {
        printf("error starting measurement\n\r");
    }
    printf("Periodic sps30 measurement started\n\n");
    nrf_delay_ms(5000);
    printf("\n");


int8_t rslt = BME280_OK;
uint8_t dev_addr = BME280_I2C_ADDR_PRIM;

dev.intf_ptr = &dev_addr;
dev.intf = BME280_I2C_INTF;
dev.read = bme280_i2c_read;
dev.write = bme280_i2c_write;
dev.delay_us = bme280_delay_us;
nrf_delay_ms(1000);
printf("Inizio\n");
nrf_delay_ms(1000);
rslt = bme280_init(&dev);
printf("BME280 init: %d\n", rslt);

uint8_t settings_sel;
struct bme280_data comp_data;

//Recommended mode of operation: Indoor navigation 
dev.settings.osr_h = BME280_OVERSAMPLING_1X;
dev.settings.osr_p = BME280_OVERSAMPLING_16X;
dev.settings.osr_t = BME280_OVERSAMPLING_2X;
dev.settings.filter = BME280_FILTER_COEFF_16;
dev.settings.standby_time = BME280_STANDBY_TIME_62_5_MS;
settings_sel = BME280_OSR_PRESS_SEL;
settings_sel |= BME280_OSR_TEMP_SEL;
settings_sel |= BME280_OSR_HUM_SEL;
settings_sel |= BME280_STANDBY_SEL;
settings_sel |= BME280_FILTER_SEL;
rslt = bme280_set_sensor_settings(settings_sel, &dev);
printf("BME280 set sensor settings: %d\n", rslt);
rslt = bme280_set_sensor_mode(BME280_NORMAL_MODE, &dev);
printf("BME280 set sensor mode: %d\n", rslt);

    timer_init();       //INIZIALIZZAZIONE DEL TIMER
    nrfx_timer_enable(&TIMER_LED);

    while (1)
    {
         __WFI();//GO INTO LOW POWER MODE
    }
}

/** @} */
