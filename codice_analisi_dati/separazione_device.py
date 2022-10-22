globals().clear()

#ATTENZIONE, PREPARARE I FILE PRIMA SU EXCEL. MI DISPIACE PER QUESTO PASSAGGIO AGGIUNTIVO MA E' STATO NECESSARIO PER MANCANZA DI TEMPO

# PARAMETERS SELECTION
filename = '1.txt'       #Inserire nome del file di Environmental Monitor
numero_step = "A"
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

P = '[04]'
IMU1 = '[01]'
IMU2 = '[02]'
IMU3 = '[03]'

start_time = time.time()

##  ENVIRONMENTAL CONTENTS  ##
E_dev = []
E_packnumber = []
E_temperatura = []
E_umidita = []
E_pressione = []
E_VOC = []
E_CO2 = []
E_NO2 = []
E_CO = []
E_PM1 = []
E_PM2P5 = []
E_PM10 = []
E_accel = []
E_P1 = []
E_P2 = []
E_P3 = []
E_data = []
E_ora  = []
E_lat = []
E_long = []

ALTRO = []
PULSIOSSIMETRO = []
IMU = []

count_environmental = 0
count_pulsossimetro = 0
count_IMU = 0

D = '[FF]'
dummy_message_Pulse = 0
dummy_message_IMU = 0

data = pd.read_csv(filename, sep=";", header=None, engine='python', skiprows=7)
print(data)
length = len(data)
print("Il dataset ha", length, "campioni")

for i in range(0, length):
    #if (not data[19].get(i)):
    if (data[0].get(i) == "6"):     #SELEZIONA DATI DA ENVIRONMENTAL MONITOR
    
            #data[0] -> numero device               #data[10] -> PM2p5
            #data[1] -> numero pacchetto            #data[11] -> PM10
            #data[2] -> temperatura                 #data[12] -> Accelerazione
            #data[3] -> humidità                    #data[13] -> P1
            #data[4] -> pressione                   #data[14] -> P2
            #data[5] -> VOC                         #data[15] -> P3
            #data[6] -> CO2                         #data[16] -> data
            #data[7] -> NO2                         #data[17] -> ora
            #data[8] -> CO                          #data[18] -> Latitudine
            #data[9] -> PM1                         #data[19] -> Longitudine

        E_dev.append([data[0].get(i)])
        E_packnumber.append([data[1].get(i)])
        E_temperatura.append([data[2].get(i)])
        E_umidita.append([data[3].get(i)])
        E_pressione.append([data[4].get(i)])
        E_VOC.append([data[5].get(i)])
        E_CO2.append([data[6].get(i)])
        E_NO2.append([data[7].get(i)])
        E_CO.append([data[8].get(i)])
        E_PM1.append([data[9].get(i)])
        E_PM2P5.append([data[10].get(i)])
        E_PM10.append([data[11].get(i)])
        E_accel.append([data[12].get(i)])
        E_P1.append([data[13].get(i)])
        E_P2.append([data[14].get(i)])
        E_P3.append([data[15].get(i)])
        E_data.append([data[16].get(i)])
        E_ora.append([data[17].get(i)])
        E_lat.append([data[18].get(i)])
        E_long.append([data[19].get(i)])

        count_environmental = count_environmental +1    
        
    else:
        #print("IMU o accelerometro")
        stringa = data[0].get(i)
        A = stringa.split(',')

        if (A[0] == P):     #CASO PULSIOSSIMETRO
            count_pulsossimetro = count_pulsossimetro + 1
            if(A[2] == D):
                #dummy message
                dummy_message_Pulse = dummy_message_Pulse +1
            else:
                PULSIOSSIMETRO.append([data[0].get(i)])
                
        
        if(A[0] == IMU1 or A[0] == IMU2 or A[0] == IMU3):
            count_IMU = count_IMU + 1
            if(A[2] == D):
                #dummy message
                dummy_message_IMU = dummy_message_IMU +1
            else:
                IMU.append([data[0].get(i)])
                
            



data = data.reset_index(drop=True)  # reset the indexes order

Device = pd.DataFrame(E_dev)
Number = pd.DataFrame(E_packnumber)
Temperatura = pd.DataFrame(E_temperatura)
Umidita = pd.DataFrame(E_umidita)
Pressione = pd.DataFrame(E_pressione)
VOC = pd.DataFrame(E_VOC)
CO2 = pd.DataFrame(E_CO2)
NO2 = pd.DataFrame(E_NO2)
CO = pd.DataFrame(E_CO)
PM1 = pd.DataFrame(E_PM1)
PM2P5 = pd.DataFrame(E_PM2P5)
PM10 = pd.DataFrame(E_PM10)
Accel = pd.DataFrame(E_accel)
P1 = pd.DataFrame(E_P1)
P2 = pd.DataFrame(E_P2)
P3 = pd.DataFrame(E_P3)
Data = pd.DataFrame(E_data)
Ora = pd.DataFrame(E_ora)
Lat = pd.DataFrame(E_lat)
Long = pd.DataFrame(E_long)

risultatoE = pd.concat([Device,Number,Temperatura,Umidita,Pressione,VOC,CO2,NO2,CO,PM1,PM2P5,PM10,Accel,P1,P2,P3,Data,Ora,Lat,Long], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt(numero_step+'_ENV_'+soggetto_numero+'.txt', risultatoE, fmt='%s')

PULS = pd.DataFrame(PULSIOSSIMETRO)

risultatoP = pd.concat([PULS], axis = 1)
np.savetxt(numero_step+'_PULSE'+soggetto_numero+'.txt', risultatoP, fmt='%s')

IMUS = pd.DataFrame(IMU)

risultatoI = pd.concat([IMUS], axis = 1)
np.savetxt(numero_step+'_IMU'+soggetto_numero+'.txt', risultatoI, fmt='%s')




print("Il dataset ha", count_environmental, "campioni di Environmental")
print("Il dataset ha", count_pulsossimetro, "campioni di Pulsiossimetro")
print("Il dataset ha", count_IMU, "campioni di IMU")

if (count_pulsossimetro == 0):
    dataloss_P = 0
else:
    dataloss_P  = round(dummy_message_Pulse/count_pulsossimetro,2)

if (count_IMU == 0):
    dataloss_I = 0
else:
    dataloss_I = round(dummy_message_IMU/count_IMU,2)



print("Data loss Pulse ", dataloss_P)
print("Data loss IMU ", dataloss_I)

f = open("INFO.txt", "x")
f.write("Il dataset ha "+ str(length)+ " campioni:\n"
+ str(count_environmental)+ " campioni di Environmental\n"
+ str(count_pulsossimetro)+ " campioni di Pulsiossimetro\n"
+ str(count_IMU)+ " campioni di IMU\n\n"
+ "Data loss Pulsiossimetro: " + str(dataloss_P)
+ "\nData loss IMU: " + str(dataloss_I))