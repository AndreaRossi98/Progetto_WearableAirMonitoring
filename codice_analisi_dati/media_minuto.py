globals().clear()

#ATTENZIONE, PREPARARE I FILE PRIMA SU EXCEL. MI DISPIACE PER QUESTO PASSAGGIO AGGIUNTIVO MA E' STATO NECESSARIO PER MANCANZA DI TEMPO

# PARAMETERS SELECTION
filename_EM = 'prova.txt'       #Inserire nome del file di Environmental Monitor
filename_Pulse = 'prova1_P.txt'    #Inserire nome del file di Pulse oximeter
filename_IMUs = 'prova.txt'     #Inserire nome del file di IMUs
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
################################
# ENVIRONMENTALMONITOR SECTION #
################################
#lettura dati Environmental Monitor
dataE = pd.read_csv(filename_EM, sep=";|:", header=None, engine='python')
print(dataE)
dataE.columns = ['temperature', 'humidity', 'pressure', 'VOC', 'CO2', 'NO2', 'CO', 'PM1.0', 'PM2p5', 'PM10', 'tempo_trascorso']
dataE = dataE.reset_index(drop=True)  # reset the indexes order
length = len(dataE)
print("Il dataset Environmental ha", length, "campioni")

# GLOBAL VARIABLES INITIALIZATION

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

dataE['temperature'] = dataE['temperature'].apply(float)
dataE['humidity'] = dataE['humidity'].apply(float)
dataE['pressure'] = dataE['pressure'].apply(float)
dataE['VOC'] = dataE['VOC'].apply(float)
dataE['CO2'] = dataE['CO2'].apply(float)
dataE['NO2'] = dataE['NO2'].apply(float)
dataE['CO'] = dataE['CO'].apply(float)
dataE['PM1'] = dataE['PM1'].apply(float)
dataE['PM2p5'] = dataE['PM2p5'].apply(float)
dataE['PM10'] = dataE['PM10'].apply(float)
dataE['tempo_trascorso'] = dataE['tempo_trascorso'].astype(int)

#medio i dati al minuto del monitor ambientale
for i in range(1, dataE['tempo_trascorso'].get(length-1)):
    if dataE['temperature'].get(j) == None:
        print("ultimo valore")
        exit
    else:
        #print("T", dataE['temperature'].get(j))
        if dataE['tempo_trascorso'].get(j) <= i:
            j = j +1  

        if dataE['temperature'].get(j) == 0:
            temperature_null = temperature_null +1
        else:
            temperature = temperature + dataE['temperature'].get(j)
        if dataE['humidity'].get(j) == 0:
            humidity_null = humidity_null +1    
        else:
            humidity = humidity + dataE['humidity'].get(j)
        if dataE['pressure'].get(j) == 0:
            pressure_null = pressure_null +1    
        else:
            pressure = pressure + dataE['pressure'].get(j)
        if dataE['VOC'].get(j) == 0:
            VOC_null = VOC_null +1    
        else:
            VOC = VOC + dataE['VOC'].get(j)
        if dataE['CO2'].get(j) == 0:
            CO2_null = CO2_null +1    
        else:
            CO2 = CO2 + dataE['CO2'].get(j)
        if dataE['CO'].get(j) == 0:
            CO_null = CO_null +1    
        else:
            CO = CO + dataE['CO'].get(j)
        if dataE['NO2'].get(j) == 0:
            NO2_null = NO2_null +1    
        else:
            NO2 = NO2 + dataE['NO2'].get(j)
        if dataE['PM1'].get(j) == 0:
            PM1_null = PM1_null +1    
        else:
            PM1 = PM1 + dataE['PM1'].get(j)
        if dataE['PM2p5'].get(j) == 0:
            PM2p5_null = PM2p5_null +1    
        else:
            PM2p5 = PM2p5 + dataE['PM2p5'].get(j)
        if dataE['PM10'].get(j) == 0:
            PM10_null = PM10_null +1    
        else:
            PM10 = PM10 + dataE['PM10'].get(j)

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



risultatoE = pd.concat([Minutes,Temps,Hums,Press,VOCs,CO2s,COs,NO2s,PM1s,PM2p5s,PM10s], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt('Soggetto_'+soggetto_numero+'_ENV.txt', risultatoE, fmt='%.2f')
print("Dati monitor ambientali correttamente mediati")


##########################
# PULSE OXEMETER SECTION #
#####à####################
#lettura dati Pulse Ox      dati subito non funziona, elaborarli prima in EXCEL         dimnuire quindi le colonne di interesse
dataP = pd.read_csv(filename_Pulse, sep=";",header=None, engine='python')
print(dataP)
dataP.columns = ['HR','tempo_trascorso']
dataP = dataP.reset_index(drop=True) # reset the indexes order
length = len(dataP)
print("Il dataset Pulsossimetro ha", length, "campioni")

dataP['HR'] = dataP['HR'].astype(int)
dataP['tempo_trascorso'] = dataP['tempo_trascorso'].astype(int)

#medio al minuto i valori di heart rate del pulsiossimetro
HR = 0
mean_HR = []
tempP = []
i = 0
j = 0
z = 0
minuti = 0

for i in range(1, dataP['tempo_trascorso'].get(length-1)):    
    if dataP['HR'].get(j) == None:
        print("ultimo valore")
        exit
    else:
        #print("HR", dataP['HR'].get(j))
        if dataP['tempo_trascorso'].get(j) <= i:
            j = j +1  

        HR = HR + dataP['HR'].get(j)

        if i % 59 == 0:
            HR = HR/60
            mean_HR.append([HR])
            tempP.append([int(minuti)])
           
            HR = 0
            minuti = minuti + 1


MinutePuls = pd.DataFrame(tempP, columns=["Minuti"])
HRs = pd.DataFrame(mean_HR, columns=["HR"])        

risultatoP = pd.concat([MinutePuls,HRs], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt('Soggetto_'+soggetto_numero+'_Puls.txt', risultatoP, fmt='%.1f')
print("Dati pulsossimetro correttamente mediati")



#################
# IMUs SECTION #
#################
#lettura dati frequenza IMUs      dati subito non funziona, elaborarli prima in EXCEL
dataIMU = pd.read_csv(filename_IMUs, sep=";",header=None, engine='python')
print(dataIMU)
dataIMU.columns = ['Freq']
dataIMU = dataIMU.reset_index(drop=True) # reset the indexes order
length = len(dataIMU)
print("Il dataset Frequenza ha", length, "campioni")

dataIMU['Freq'] = dataIMU['Freq'].astype(float)

#medio al minuto i valori di frequenza respiratoria delle IMUs
Freq = 0
mean_Freq = []
tempP = []
i = 0
j = 0
z = 0
minuti = 0

for i in range(1, dataP['tempo_trascorso'].get(length-1),2):    
    print(i)
    if dataIMU['Freq'].get(i) == None:
        #print("ultimo valore")
        exit
    else:
        if dataIMU['Freq'].get(i) != None:
            if dataIMU['Freq'].get(i+1) != None:
                Freq = (dataIMU['Freq'].get(i) + dataIMU['Freq'].get(i+1))/2
                mean_Freq.append([Freq])
            if dataIMU['Freq'].get(i+1) == None:
                mean_Freq.append([dataIMU['Freq'].get(i)])



Freqs = pd.DataFrame(mean_Freq, columns=["Freq"])        


#SALVATAGGIO DATI SU TXT
np.savetxt('Soggetto_'+soggetto_numero+'_Freq.txt', Freqs, fmt='%.1f')
print("Dati frequenza correttamente mediati")