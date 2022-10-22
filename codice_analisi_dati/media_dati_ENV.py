globals().clear()
# PARAMETERS SELECTION
filename = 'prova.txt'        #Inserire nome del file
soggetto_numero = 0           #Inserire numero del soggetto
soggetto_numero = str(soggetto_numero)
#A:sit.wo.su,Luca C - 23_03_15_45_04_841.txt B:sit, C:supine, D:prone, E:lyingL, F:lyingR, G:standing, I:stairs, L:walkS, M:walkF, N:run, O:cyclette
window_size = 600  # samples inside the window (Must be >=SgolayWindowPCA). 1 minute = 600 samples
SgolayWindowPCA = 31  # original: 31.  MUST BE AN ODD NUMBER
start = 0  # number of initial samples to skip (samples PER device)
stop = 0  # number of sample at which program execution will stop, 0 will run the txt file to the end
incr = 300  # Overlapping between a window and the following. 1=max overlap. MUST BE >= SgolayWindowPCA. The higher the faster
# PLOTTING & COMPUTING OPTIONS
timeinminutes = 1 #1: grafici in minuti, 0: grafici in numero di campioni (1 min = 600 campioni)
w1plot = 1  # 1 enables plotting quaternions and PCA, 0 disables it
w2plot = 1  # 1 enables plotting respiratory signals and spectrum, 0 disables it
resp_param_plot = 1  # 1 enables plotting respiratory frequency and duty cycle, 0 disables it
batteryplot = 1  # 1 enables plotting battery voltages, 0 disables it
prediction_enabled = 0  # 1 enables posture prediction, 0 disables it
# THRESHOLDS
f_threshold_max = 0.75 #originale 0.75
f_threshold_min = 0.05 #originale 0.05


from ctypes import sizeof

from tempfile import TemporaryDirectory
import pandas as pd
import math
import matplotlib.pyplot as plt
import statistics
from pyquaternion import Quaternion
import numpy as np
import scipy.signal
from sklearn.decomposition import PCA
import scipy.stats as stats
import warnings
import time


start_time = time.time()

#T[°C]	RH[%]	P[Pa]	VOC	CO2	NO2	CO	PM1.0	PM2.5	PM10	tempo da inizio
#togliere PM1 e pm10
data = pd.read_csv(filename, sep=";|:", header=None, engine='python')
print(data)
data.columns = ['temperature', 'humidity', 'pressure', 'VOC', 'CO2', 'NO2', 'CO', 'PM1.0', 'PM2p5', 'PM10', 'tempo_trascorso']
data = data.reset_index(drop=True)  # reset the indexes order
length = len(data)
print("Il dataset ha", length, "campioni")
#print(data)

# GLOBAL VARIABLES INITIALIZATION
flag = 0
i = 0
j = 0
z = 0
minuti = 0
temperature = 0
humidity = 0
pressure = 0
VOC = 0
CO2 = 0
CO = 0
NO2 = 0
PM1 = 0
PM2p5 = 0
PM10 = 0
temperature_null = 0
humidity_null = 0
pressure_null = 0
VOC_null = 0
CO2_null = 0
CO_null = 0
NO2_null = 0
PM1_null = 0
PM2p5_null = 0 
PM10_null = 0
mean_temperature = []
mean_humidity = []
mean_pressure = []
mean_VOC = []
mean_CO2 = []
mean_CO = []
mean_NO2 = []
mean_PM1 = []
mean_PM2p5 = []
mean_PM10 = []
temp = []


data['temperature'] = data['temperature'].astype(str)
data['temperature'] = data['temperature'].apply(float)

data['humidity'] = data['humidity'].astype(str)
data['humidity'] = data['humidity'].apply(float)

data['pressure'] = data['pressure'].astype(str)
data['pressure'] = data['pressure'].apply(float)

data['VOC'] = data['VOC'].astype(str)
data['VOC'] = data['VOC'].apply(float)

data['CO2'] = data['CO2'].astype(str)
data['CO2'] = data['CO2'].apply(float)

data['NO2'] = data['NO2'].astype(str)
data['NO2'] = data['NO2'].apply(float)

data['CO'] = data['CO'].astype(str)
data['CO'] = data['CO'].apply(float)

data['PM1'] = data['PM1'].astype(str)
data['PM1'] = data['PM1'].apply(float)

data['PM2p5'] = data['PM2p5'].astype(str)
data['PM2p5'] = data['PM2p5'].apply(float)

data['PM10'] = data['PM10'].astype(str)
data['PM10'] = data['PM10'].apply(float)

data['tempo_trascorso'] = data['tempo_trascorso'].astype(int)
#data['tempo_trascorso'] = data['tempo_trascorso'].apply(float)


#MEDIA I DATI OGNI UN MIUTO
for i in range(1, data['tempo_trascorso'].get(length-1)):
    if data['temperature'].get(j) == None:
        print("ultimo valore")
        exit
    else:
        #print("T", data['temperature'].get(j))
        if data['tempo_trascorso'].get(j) <= i:
            j = j +1  

        if data['temperature'].get(j) == 0:
            temperature_null = temperature_null +1
        else:
            temperature = temperature + data['temperature'].get(j)
        if data['humidity'].get(j) == 0:
            humidity_null = humidity_null +1    
        else:
            humidity = humidity + data['humidity'].get(j)
        if data['pressure'].get(j) == 0:
            pressure_null = pressure_null +1    
        else:
            pressure = pressure + data['pressure'].get(j)
        if data['VOC'].get(j) == 0:
            VOC_null = VOC_null +1    
        else:
            VOC = VOC + data['VOC'].get(j)
        if data['CO2'].get(j) == 0:
            CO2_null = CO2_null +1    
        else:
            CO2 = CO2 + data['CO2'].get(j)
        if data['CO'].get(j) == 0:
            CO_null = CO_null +1    
        else:
            CO = CO + data['CO'].get(j)
        if data['NO2'].get(j) == 0:
            NO2_null = NO2_null +1    
        else:
            NO2 = NO2 + data['NO2'].get(j)
        if data['PM1'].get(j) == 0:
            PM1_null = PM1_null +1    
        else:
            PM1 = PM1 + data['PM1'].get(j)
        if data['PM2p5'].get(j) == 0:
            PM2p5_null = PM2p5_null +1    
        else:
            PM2p5 = PM2p5 + data['PM2p5'].get(j)
        if data['PM10'].get(j) == 0:
            PM10_null = PM10_null +1    
        else:
            PM10 = PM10 + data['PM10'].get(j)

        if i % 59 == 0:
            temperature = round(temperature / ( 60 - temperature_null ),2)
            humidity = round(humidity / ( 60 - humidity_null ),2)
            pressure = round(pressure /(60 - pressure_null),2)
            VOC = round(VOC /(60 - VOC_null),2)
            CO2 = round(CO2 /(60 - CO2_null),2)
            CO = round(CO /(60 - CO_null),2)
            NO2 = round(NO2 /(60 - NO2_null),2)
            PM1 = round(PM1 /(60 - PM1_null),2)
            PM2p5 = round(PM2p5 /(60 - PM2p5_null),2)
            PM10 = round(PM10 /(60 - PM10_null),2)
            
            temp.append([int(minuti)])
            mean_temperature.append([temperature])
            mean_humidity.append([humidity])
            mean_pressure.append([pressure])
            mean_VOC.append([VOC])
            mean_CO2.append([CO2])
            mean_CO.append([CO])
            mean_NO2.append([NO2])
            mean_PM1.append([PM1])
            mean_PM2p5.append([PM2p5])
            mean_PM10.append([PM10])
            
            temperature = 0
            humidity = 0
            pressure = 0
            VOC = 0
            CO2 = 0
            CO = 0
            NO2 = 0
            PM1 = 0
            PM2p5 = 0
            PM10 = 0
            
            temperature_null = 0
            humidity_null = 0
            pressure_null = 0
            VOC_null = 0
            CO2_null = 0
            CO_null = 0
            NO2_null = 0
            PM1_null = 0
            PM2p5_null = 0
            PM10_null = 0

            z = z + 1
            minuti = minuti +1

Minutes = pd.DataFrame(temp, columns=["Minuti"])
Temps = pd.DataFrame(mean_temperature, columns=["T"])
Hums = pd.DataFrame(mean_humidity, columns=["RH"])
Press = pd.DataFrame(mean_pressure, columns=["P"])
VOCs = pd.DataFrame(mean_VOC, columns=["VOC"])
CO2s = pd.DataFrame(mean_CO2, columns=["CO2"])
COs = pd.DataFrame(mean_CO, columns=["CO"])
NO2s = pd.DataFrame(mean_NO2, columns=["NO2"])
PM1s = pd.DataFrame(mean_PM1, columns=["PM1"])
PM2p5s = pd.DataFrame(mean_PM2p5, columns=["PM2.5"])
PM10s = pd.DataFrame(mean_PM10, columns=["PM10"])


risultato = pd.concat([Minutes,Temps,Hums,Press,VOCs,CO2s,COs,NO2s,PM1s,PM2p5s,PM10s], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt('Soggetto_'+soggetto_numero+'.txt', risultato, fmt='%.2f')