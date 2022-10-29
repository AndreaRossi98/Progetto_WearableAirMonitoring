globals().clear()

#ATTENZIONE, PREPARARE I FILE PRIMA SU EXCEL. MI DISPIACE PER QUESTO PASSAGGIO AGGIUNTIVO MA E' STATO NECESSARIO PER MANCANZA DI TEMPO

# PARAMETERS SELECTION
filename = 'Soggetto01.txt'       #Inserire nome del file di Environmental Monitor

soggetto_numero = 0           #Inserire numero del soggetto
soggetto_numero = str(soggetto_numero)
righe_da_saltare = 26       #inserire numero di riga in cui c'è scritta start
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
from re import A

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

import datetime

import math
import numpy as np
import matplotlib.pyplot as plt 
import re
# x=np.linspace(0,2*math.pi,100)
# y=np.sin(x)

# fig,axes=plt.subplots(1,1)

# axes.plot(x, y)
# axes.xaxis.set_ticks([0,1,2,3,4,5,6])  
# axes.yaxis.set_ticks(np.linspace(-1,1,5))       
# axes.set_title("Sinx Function")
# axes.set_xlabel("X")
# axes.set_ylabel("sinX")
# plt.show()



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
E_tempo  = []
E_lat = []
E_long = []
E_packet_persi = 0

data = pd.read_csv(filename, sep=";", header=None, engine='python', skiprows=righe_da_saltare)
print(data)
length = len(data)
print("Il dataset ha", length, "campioni")
for i in range(0, length):
    if (data[0].get(i) == "6" and data[1].get(i)!= "0"):
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
        E_tempo.append([data[17].get(i)])




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

P1 = pd.DataFrame(E_P1)
P2 = pd.DataFrame(E_P2)
P3 = pd.DataFrame(E_P3)
Data = pd.DataFrame(E_data)
Tempo = pd.DataFrame(E_tempo)

risultatoE = pd.concat([Temperatura,Umidita,Pressione,VOC,CO2,NO2,CO,PM1,PM2P5,PM10,Data,Tempo,P1,P2,P3], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt('Data1_graph.txt', risultatoE, fmt='%s')



##  ENVIRONMENTAL CONTENTS  ##
E_temperatura = []
T_temperatura = []
E_umidita = []
E_pressione = []
E_VOC = []
T_VOC = []
E_CO2 = []
E_NO2 = []
E_CO = []
E_PM1 = []
T_PM1 = []
E_PM2P5 = []
E_PM10 = []

E_P1 = []
E_P2 = []
E_P3 = []
E_data = []
E_time  = []

data = pd.read_csv('Data1_graph.txt', sep=" ", header=None, engine='python', skiprows=0)
#print(data)
length = len(data)
print("Il dataset ha", length, "campioni")

for i in range(0, length):
    if(data[12].get(i) != 0.0):
        E_temperatura.append([data[0].get(i)])
        E_umidita.append([data[1].get(i)])
        E_pressione.append([data[2].get(i)])
        T_temperatura.append([data[11].get(i)])
    
    if(data[13].get(i) != 0.0):
        E_VOC.append([data[3].get(i)])
        E_CO2.append([data[4].get(i)])
        E_NO2.append([data[5].get(i)])
        E_CO.append([data[6].get(i)])
        T_VOC.append([data[11].get(i)])

    if(data[14].get(i) != 0.0):
        E_PM1.append([data[7].get(i)])
        E_PM2P5.append([data[8].get(i)])
        E_PM10.append([data[9].get(i)])
        T_PM1.append([data[11].get(i)])


data = data.reset_index(drop=True)  # reset the indexes order

#ENVIRONMENTAL SALVATAGGIO TXT

Temperatura = pd.DataFrame(E_temperatura)
Umidita = pd.DataFrame(E_umidita)
Pressione = pd.DataFrame(E_pressione)
Tempo1 = pd.DataFrame(T_temperatura)
VOC = pd.DataFrame(E_VOC)
CO2 = pd.DataFrame(E_CO2)
NO2 = pd.DataFrame(E_NO2)
CO = pd.DataFrame(E_CO)
Tempo2 = pd.DataFrame(T_VOC)
PM1 = pd.DataFrame(E_PM1)
PM2P5 = pd.DataFrame(E_PM2P5)
PM10 = pd.DataFrame(E_PM10)
Tempo3 = pd.DataFrame(T_PM1)

risultato1 = pd.concat([Temperatura,Umidita,Pressione,Tempo1], axis=1)
risultato2 = pd.concat([VOC,CO2,NO2,CO,Tempo2], axis=1)
risultato3 = pd.concat([PM1,PM2P5,PM10,Tempo3], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt('Data1_graph.txt', risultato1, fmt='%s')
np.savetxt('Data2_graph.txt', risultato2, fmt='%s')
np.savetxt('Data3_graph.txt', risultato3, fmt='%s')
