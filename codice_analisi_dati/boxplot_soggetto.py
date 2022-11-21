globals().clear()

# PARAMETERS SELECTION
filename2 = 'Data2_graph.txt'       
filename3 = 'Data3_graph.txt' 

#inserire inizio tempo inizio acquisizione statica, tempo fine calcolato in automatico con incremento di 5 minuti
timeA_i = "10:21:12"
timeB_i = "10:40:20"
timeC_i = "10:49:10"
timeD_i = "11:00:05"
timeE_i = "11:20:10"
timeF_i = "11:35:05"
timeG_i = "11:50:30"

soggetto_numero = "01"           #Inserire numero del soggetto
righe_da_saltare = 0



from ctypes import sizeof
from re import A
from sqlite3 import TimeFromTicks

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
from datetime import timedelta

import math
import numpy as np
import matplotlib.pyplot as plt 
import re


def incremento_5_minuti (orario):
    minuto = orario.minute
    ora = orario.hour
    minuto = minuto +5
    if (minuto > 59):
        minuto = minuto - 60
        ora = ora +1
    return ora, minuto

A_VOC = []
A_CO2 = [] 
A_PM1p0 = [] 
A_PM2p5 = [] 
A_PM10 = []
B_VOC = [] 
B_CO2 = [] 
B_PM1p0 = [] 
B_PM2p5 = []
B_PM10 = []
C_VOC = [] 
C_CO2 = [] 
C_PM1p0 = [] 
C_PM2p5 = [] 
C_PM10 = []
D_VOC = [] 
D_CO2 = [] 
D_PM1p0 = [] 
D_PM2p5 = [] 
D_PM10 = []
E_VOC = [] 
E_CO2 = []
E_PM1p0 = [] 
E_PM2p5 = [] 
E_PM10 = []
F_VOC = [] 
F_CO2 = [] 
F_PM1p0 = [] 
F_PM2p5 = [] 
F_PM10 = []
G_VOC = [] 
G_CO2 = [] 
G_PM1p0 = []
G_PM2p5 = [] 
G_PM10 = []

########################################################################
# Definizione degli orari di inizio e fine delle acquisizioni statiche #
########################################################################
#limite temporale acquisizione punto A
hour,minute,sec = timeA_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeA_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeA_i)
timeA_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto B
hour,minute,sec = timeB_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeB_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeB_i)
timeB_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto C
hour,minute,sec = timeC_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeC_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeC_i)
timeC_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto D
hour,minute,sec = timeD_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeD_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeD_i)
timeD_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto E
hour,minute,sec = timeE_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeE_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeE_i)
timeE_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto F
hour,minute,sec = timeF_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeF_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeF_i)
timeF_f = datetime.time(hour_f, minute_f,sec)

#limite temporale acquisizione punto G
hour,minute,sec = timeG_i.split(':')
hour = int(hour)
minute = int(minute)
sec = int(sec)
timeG_i = datetime.time(hour, minute, sec)
hour_f , minute_f = incremento_5_minuti(timeG_i)
timeG_f = datetime.time(hour_f, minute_f,sec)

######################################
# LETTURA DEL FILE CONTENENTE I DATI #
######################################
data2 = pd.read_csv(filename2, sep=" ", header=None, engine='python', skiprows=righe_da_saltare)
length = len(data2)
print("Il dataset ha", length, "campioni")
print(data2)

for i in range(0, length):
    tempo = str(data2[4].get(i))
    
    hour,minute,sec = tempo.split(':')
    hour = int(hour)
    minute = int(minute)
    sec = int(sec)
    tempo = datetime.time(hour, minute, sec)


    if (tempo > timeA_i and tempo < timeA_f):
        #ACQUISIZIIONE A
        A_VOC.append([data2[0].get(i)])
        A_CO2.append([data2[1].get(i)])

    else:
        if(tempo > timeB_i and tempo < timeB_f):
            #ACQUISIZIONE B
            B_VOC.append([data2[0].get(i)])
            B_CO2.append([data2[1].get(i)])
        else:
            if(tempo > timeC_i and tempo < timeC_f):
                #ACQUISIZIONE C
                C_VOC.append([data2[0].get(i)])
                C_CO2.append([data2[1].get(i)])
            else:
                if(tempo > timeD_i and tempo < timeD_f):
                    #ACQUISIZIONE D
                    D_VOC.append([data2[0].get(i)])
                    D_CO2.append([data2[1].get(i)])
                else:
                    if(tempo > timeE_i and tempo < timeE_f):
                        #ACQUISIZIONE E
                        E_VOC.append([data2[0].get(i)])
                        E_CO2.append([data2[1].get(i)])
                    else:
                        if(tempo > timeF_i and tempo < timeF_f):
                            #ACQUISIZIONE F
                            F_VOC.append([data2[0].get(i)])
                            F_CO2.append([data2[1].get(i)])

                        else:
                            if(tempo > timeG_i and tempo < timeG_f):
                                #ACQUISIZIONE G
                                G_VOC.append([data2[0].get(i)])
                                G_CO2.append([data2[1].get(i)])

data3 = pd.read_csv(filename3, sep=" ", header=None, engine='python', skiprows=righe_da_saltare)
length = len(data3)
print("Il dataset ha", length, "campioni")
print(data3)

for i in range(0, length):
    tempo = str(data3[3].get(i))
    
    hour,minute,sec = tempo.split(':')
    hour = int(hour)
    minute = int(minute)
    sec = int(sec)
    tempo = datetime.time(hour, minute, sec)


    if (tempo > timeA_i and tempo < timeA_f):
        #ACQUISIZIIONE A
        A_PM1p0.append([data3[0].get(i)])
        A_PM2p5.append([data3[1].get(i)])
        A_PM10.append([data3[2].get(i)])

    else:
        if(tempo > timeB_i and tempo < timeB_f):
            #ACQUISIZIONE B
            B_PM1p0.append([data3[0].get(i)])
            B_PM2p5.append([data3[1].get(i)])
            B_PM10.append([data3[2].get(i)])
        else:
            if(tempo > timeC_i and tempo < timeC_f):
                #ACQUISIZIONE C
                C_PM1p0.append([data3[0].get(i)])
                C_PM2p5.append([data3[1].get(i)])
                C_PM10.append([data3[2].get(i)])
            else:
                if(tempo > timeD_i and tempo < timeD_f):
                    #ACQUISIZIONE D
                    D_PM1p0.append([data3[0].get(i)])
                    D_PM2p5.append([data3[1].get(i)])
                    D_PM10.append([data3[2].get(i)])
                else:
                    if(tempo > timeE_i and tempo < timeE_f):
                        #ACQUISIZIONE E
                        E_PM1p0.append([data3[0].get(i)])
                        E_PM2p5.append([data3[1].get(i)])
                        E_PM10.append([data3[2].get(i)])
                    else:
                        if(tempo > timeF_i and tempo < timeF_f):
                            #ACQUISIZIONE F
                            F_PM1p0.append([data3[0].get(i)])
                            F_PM2p5.append([data3[1].get(i)])
                            F_PM10.append([data3[2].get(i)])

                        else:
                            if(tempo > timeG_i and tempo < timeG_f):
                                #ACQUISIZIONE G
                                G_PM1p0.append([data3[0].get(i)])
                                G_PM2p5.append([data3[1].get(i)])
                                G_PM10.append([data3[2].get(i)])



####### tVOC boxplot ################
VOC_data_A = np.concatenate((A_VOC))
VOC_data_B = np.concatenate((B_VOC))
VOC_data_C = np.concatenate((C_VOC))
VOC_data_D = np.concatenate((D_VOC))
VOC_data_E = np.concatenate((E_VOC))
VOC_data_F = np.concatenate((F_VOC))
VOC_data_G = np.concatenate((G_VOC))
fig1, ax1 = plt.subplots()
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
VOC = [VOC_data_A,VOC_data_B,VOC_data_C,VOC_data_D,VOC_data_E,VOC_data_F,VOC_data_G]
plt.boxplot(VOC)
#ax1.boxplot(data_B)
plt.xticks(x,values)
plt.title("tVOC Boxplot subject "+soggetto_numero)
plt.show()
print("boxplot tVOC")

####### CO2 boxplot ################
CO2_data_A = np.concatenate((A_CO2))
CO2_data_B = np.concatenate((B_CO2))
CO2_data_C = np.concatenate((C_CO2))
CO2_data_D = np.concatenate((D_CO2))
CO2_data_E = np.concatenate((E_CO2))
CO2_data_F = np.concatenate((F_CO2))
CO2_data_G = np.concatenate((G_CO2))
plt.figure(2)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
CO2 = [CO2_data_A,CO2_data_B,CO2_data_C,CO2_data_D,CO2_data_E,CO2_data_F,CO2_data_G]
plt.boxplot(CO2)
plt.xticks(x,values)
plt.title("CO2 Boxplot subject "+soggetto_numero)
plt.show()
print("boxplot CO2")

####### PM1.0 boxplot ################
PM1_data_A = np.concatenate((A_PM1p0))
PM1_data_B = np.concatenate((B_PM1p0))
PM1_data_C = np.concatenate((C_PM1p0))
PM1_data_D = np.concatenate((D_PM1p0))
PM1_data_E = np.concatenate((E_PM1p0))
PM1_data_F = np.concatenate((F_PM1p0))
PM1_data_G = np.concatenate((G_PM1p0))
plt.figure(3)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM1 = [PM1_data_A,PM1_data_B,PM1_data_C,PM1_data_D,PM1_data_E,PM1_data_F,PM1_data_G]
plt.boxplot(PM1)
plt.xticks(x,values)
plt.title("PM1.0 Boxplot subject "+soggetto_numero)
plt.show()
print("boxplot PM1.0")

####### PM2.5 boxplot ################
PM2p5_data_A = np.concatenate((A_PM2p5))
PM2p5_data_B = np.concatenate((B_PM2p5))
PM2p5_data_C = np.concatenate((C_PM2p5))
PM2p5_data_D = np.concatenate((D_PM2p5))
PM2p5_data_E = np.concatenate((E_PM2p5))
PM2p5_data_F = np.concatenate((F_PM2p5))
PM2p5_data_G = np.concatenate((G_PM2p5))
plt.figure(4)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM2p5 = [PM2p5_data_A,PM2p5_data_B,PM2p5_data_C,PM2p5_data_D,PM2p5_data_E,PM2p5_data_F,PM2p5_data_G]
plt.boxplot(PM2p5)
plt.xticks(x,values)
plt.title("PM2.5 Boxplot subject "+soggetto_numero)
plt.show()
print("boxplot PM2.5")

####### PM10 boxplot ################
PM10_data_A = np.concatenate((A_PM10))
PM10_data_B = np.concatenate((B_PM10))
PM10_data_C = np.concatenate((C_PM10))
PM10_data_D = np.concatenate((D_PM10))
PM10_data_E = np.concatenate((E_PM10))
PM10_data_F = np.concatenate((F_PM10))
PM10_data_G = np.concatenate((G_PM10))
plt.figure(5)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM10 = [PM10_data_A,PM10_data_B,PM10_data_C,PM10_data_D,PM10_data_E,PM10_data_F,PM10_data_G]
plt.boxplot(PM10)
plt.xticks(x,values)
plt.title("PM10 Boxplot subject "+soggetto_numero)
plt.show()
print("boxplot PM10")
