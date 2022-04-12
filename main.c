#include <stdbool.h>
#include <stdint.h>
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
    //nrf_saadc_channel_config_t channel0_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN1);
    nrf_saadc_channel_config_t channel1_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN2);
    nrf_saadc_channel_config_t channel2_config = NRFX_SAADC_DEFAULT_CHANNEL_CONFIG_SE(NRF_SAADC_INPUT_AIN3);
    channel2_config.gain = 1;
    channel1_config.gain = 1;
    //channel0_config.gain = 1;

    // Initialize the saadc 
    err_code = nrf_drv_saadc_init(NULL, saadc_callback_handler);
    APP_ERROR_CHECK(err_code);

    // Initialize the Channel which will be connected to that specific pin.
    //err_code = nrfx_saadc_channel_init(0, &channel0_config);
    //APP_ERROR_CHECK(err_code);
    err_code = nrfx_saadc_channel_init(1, &channel1_config);
    APP_ERROR_CHECK(err_code);
    err_code = nrfx_saadc_channel_init(2, &channel2_config);
    APP_ERROR_CHECK(err_code);
}

nrf_saadc_value_t adc_val;      //variable to hold the value read by the ADC

float ADC_TO_VOLTS (int adc)
{
    float volts;
    //volts = (0.00363385)*adc + 0.14411395;
    volts = (0.000884)*adc + 0.14776;
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

void timer0_handler(nrf_timer_event_t event_type, void* p_context)
{
    switch(event_type)
    {
        case NRF_TIMER_EVENT_COMPARE0:
            count++;
            nrf_gpio_pin_toggle(LED1);
            printf("%d\n\r", count);
            //nrfx_saadc_sample_convert(1, &adc_val);
            //Vref = ADC_TO_VOLTS(adc_val);
            //printf("%d\n", adc_val);
            //NRF_LOG_INFO("%d) Vref [V]: " NRF_LOG_FLOAT_MARKER ";\r",i, NRF_LOG_FLOAT(Vref));
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
    //saadc_init(); 
    
    twi_init();

    NRF_LOG_INFO("Starting the program");
    nrf_delay_ms(3000);

    

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
    
    timer_init();       //INIZIALIZZAZIONE DEL TIMER
    nrfx_timer_enable(&TIMER_LED);

//////////////////////////////
///SENSORS' INITIALIZATION////
//////////////////////////////
    lettura_scd41(3);
    lettura_sps30(1);


    while (1)
    {
         __WFI();//GO INTO LOW POWER MODE
    }
}

/** @} */
