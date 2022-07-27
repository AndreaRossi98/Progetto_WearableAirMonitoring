#include <stdio.h>
#include <stdint.h> //aggiunta dopo per vedere se cambia printf
#include "boards.h"
#include "nrf.h"
#include "nordic_common.h"
#include "app_util_platform.h"
#include "app_error.h"
#include "nrf_drv_twi.h"
#include "nrf_delay.h"
#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "nrf_log_default_backends.h"

//SENSIRION's sensor libraries
#include "sensirion_common.h"
#include "sensirion_config.h"
#include "sensirion_i2c.h"
#include "sensirion_i2c_hal.h"
#include "scd4x_i2c.h"
#include "sps30.h"

#include "reading_sps30.h"

#define SPS_CMD_READ_MEASUREMENT 0x0300

//Initialization of the sensor

void lettura_sps30(uint8_t campioni){
    struct sps30_measurement measurement;
    int16_t ret;
    int16_t error;
    uint8_t data[10][4];
    #define SPS_CMD_READ_MEASUREMENT 0x0300
    
    sps30_stop_measurement(); //provato ad aggiungere per vedere se risolve problema del probe failed ripetuto
    
    //check if the sensor is ready to start and initialize it
    while (sps30_probe() != 0) 
    {
        printf("probe failed\n\r");
        nrf_delay_ms(1000);
    }
    printf("probe succeeded\n\r");


    //start measurement and wait for 10s to ensure the sensor has a
    //stable flow and possible remaining particles are cleaned out
    if (sps30_start_measurement() != 0) 
    {
        printf("error starting measurement\n\r");
    }
    nrf_delay_ms(10000);

    for(int i=0; i < campioni; i++)
    {
        nrf_delay_ms(3000);

        ret = sps30_read_measurement(&measurement);

        if(ret < 0)
        {
            printf("read measurement failed\n\r");
        }
        else
        {
            //stampa di tutti i valori letti(mass concentration and number concentration)
            printf("Measurement n� %d: ",i+1);            
            int16_t intero;
            int16_t decimale;
            //mc_1p0
            intero = measurement.mc_1p0;
            decimale = (measurement.mc_1p0 - intero)*100;
            //printf("PM 1.0: %d.%d [�g/m�]\n\r", intero, decimale);
            //mc_2p5
            intero = measurement.mc_2p5;
            decimale = (measurement.mc_2p5 - intero)*100;
            printf("PM 2.5: %d.%d [�g/m�]\n\r", intero, decimale);
            //mc_4p0
            intero = measurement.mc_4p0;
            decimale = (measurement.mc_4p0 - intero)*100;
            //printf("PM 4.0: %d.%d [�g/m�]\n\r", intero, decimale);
            //mc_10p0
            intero = measurement.mc_10p0;
            decimale = (measurement.mc_10p0 - intero)*100;
            //printf("PM 10.0: %d.%d [�g/m�]\n\r", intero, decimale);

            //mc_0p5
            intero = measurement.nc_0p5;
            decimale = (measurement.nc_0p5 - intero)*100;
            //printf("PM 0.5: %d.%d [#/cm�]\n\r", intero, decimale);
            //mc_1p0
            intero = measurement.nc_1p0;
            decimale = (measurement.nc_1p0 - intero)*100;
            //printf("PM 1.0: %d.%d [#/cm�]\n\r", intero, decimale);
            //mc_2p5
            intero = measurement.nc_2p5;
            decimale = (measurement.nc_2p5 - intero)*100;
            //printf("PM 2.5: %d.%d [#/cm�]\n\r", intero, decimale);
            //mc_4p0
            intero = measurement.nc_4p0;
            decimale = (measurement.nc_4p0 - intero)*100;
            //printf("PM 4.0: %d.%d [#/cm�]\n\r", intero, decimale);
            //mc_10p0
            intero = measurement.nc_10p0;
            decimale = (measurement.nc_10p0 - intero)*100;
            //printf("PM 10.0: %d.%d [#/cm�]\n\r", intero, decimale);

            //typical particle size
            intero = measurement.typical_particle_size;
            decimale = (measurement.typical_particle_size - intero)*100;
            //printf("Typical particle size: %d.%d [nm]\n\r", intero, decimale);
            //printf("\n");
        }
    }

    
    
    nrf_delay_ms(1000);
    //ret = sps30_start_manual_fan_cleaning();
    nrf_delay_ms(1000);
    if (ret < 0)
    {}
    else  printf("Fan manual cleaning\r\n\n");

    nrf_delay_ms(1000);
    ret = sps30_stop_measurement();
    nrf_delay_ms(1000);
    if(ret < 0)
    {}
    else  printf("Measurement stopped\n\n\r");
}
/** @} */