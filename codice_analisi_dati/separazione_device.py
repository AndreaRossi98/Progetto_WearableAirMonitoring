globals().clear()

#ATTENZIONE, PREPARARE I FILE PRIMA SU EXCEL. MI DISPIACE PER QUESTO PASSAGGIO AGGIUNTIVO MA E' STATO NECESSARIO PER MANCANZA DI TEMPO

# PARAMETERS SELECTION
filename = 'E.txt'       #Inserire nome del file di Environmental Monitor
numero_step = "E"
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
import datetime

P = '[04]'
IMU1 = '[01]'
IMU2 = '[02]'
IMU3 = '[03]'

start_time = time.time()

#flag per predenere orario primo campione   (funzione di time di python non mi funziona, mi sono arrangiato)
E_flag_primo = 0
P_flag_primo = 0
I_flag_primo = 0

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
E_minuto = []
E_secondo =[]
E_lat = []
E_long = []

## PULSEOXEMETER CONTENTS ##
P_dev = []
P_saturation =  []
P_activity = []
P_counter_algo = []
P_R_value = []
P_HR = []
P_SpO2 = []
P_SCDstate = []
P_giorno = []
P_mese = []
P_ora =[]
P_minuto = []
P_secondo = []
P_millisecondo = []

## IMU CONTENTS ##
I_dev = []
I_uno =  []
I_due = []
I_tre = []
I_quattro = []
I_cinque = []
I_sei = []
I_sette = []
I_giorno = []
I_mese = []
I_ora =[]
I_minuto = []
I_secondo = []
I_millisecondo = []



ALTRO = []
PULSIOSSIMETRO = []
IMU = []

count_environmental = 0
count_pulsossimetro = 0
count_IMU = 0

D = '[FF]'
dummy_message_Pulse = 0
dummy_message_IMU = 0

data = pd.read_csv(filename, sep=";|:|,", header=None, engine='python', skiprows=6)
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
            #data[7] -> NO2                         #data[17] -> ora    #data[18] -> minuto     #data[19] -> secondo
            #data[8] -> CO                          #data[20] -> Latitudine
            #data[9] -> PM1                         #data[21] -> Longitudine

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
        E_minuto.append([data[18].get(i)])
        E_secondo.append([data[19].get(i)])
        E_lat.append([data[20].get(i)])
        E_long.append([data[21].get(i)])
        if(E_flag_primo == 0):
            E_inizio_ora = int(data[17].get(i))
            E_inizio_minuto = int(data[18].get(i))
            E_inizio_secondo = int(data[19].get(i))
            E_flag_primo = 1
        else:
            E_fine_ora = int(data[17].get(i))
            E_fine_minuto = int(data[18].get(i))
            E_fine_secondo = int(data[19].get(i))

        count_environmental = count_environmental +1    
        
    else:
        #print("IMU o accelerometro")
        #data[0] -> numero device               #data[10] -> ora
        #data[1] -> primop                      #data[11] -> minuto
        #data[2] -> secondop                    #data[12] -> secondo
        #data[3] -> terzop                      #data[13] -> millisecondo
        #data[4] -> quartop                   
        #data[5] -> quintop                      
        #data[6] -> sestop                         
        #data[7] -> settimop                         
        #data[8] -> giorno                          
        #data[9] -> mese 


        stringa = data[0].get(i)
        #A = stringa.split(',')

        if (data[0].get(i) == P):     #CASO PULSIOSSIMETRO
            count_pulsossimetro = count_pulsossimetro + 1
            if(data[2].get(i) == D):
                #dummy message
                dummy_message_Pulse = dummy_message_Pulse +1
            else:

                P_Device = pd.DataFrame(P_dev)



                elaborazione = data[0].get(i)
                elaborazione = elaborazione.replace('[', '')
                elaborazione = elaborazione.replace(']', '')
                elaborazione = int(elaborazione, base=16)
                P_dev.append(elaborazione)
                P_saturation.append([data[1].get(i)])

                elaborazione = data[2].get(i)
                elaborazione = elaborazione.replace('[', '')
                elaborazione = elaborazione.replace(']', '')
                elaborazione = int(elaborazione, base=16)
                P_activity.append(elaborazione) #[data[2].get(i)]
                P_counter_algo.append([data[3].get(i)])
                P_R_value.append([data[4].get(i)])

                elaborazione = data[5].get(i)
                elaborazione = elaborazione.replace('[', '')
                elaborazione = elaborazione.replace(']', '')
                elaborazione = int(elaborazione, base=16)
                P_HR.append(elaborazione)  #[data[5].get(i)]

                elaborazione = data[6].get(i)
                elaborazione = elaborazione.replace('[', '')
                elaborazione = elaborazione.replace(']', '')
                elaborazione = int(elaborazione, base=16)
                P_SpO2.append(elaborazione) #[data[6].get(i)]

                elaborazione = data[7].get(i)
                elaborazione = elaborazione.replace('[', '')
                elaborazione = elaborazione.replace(']', '')
                P_SCDstate.append(elaborazione)

                elaborazione = int(data[8].get(i))
                P_giorno.append(elaborazione)
                elaborazione = int(data[9].get(i))
                P_mese.append(elaborazione)
                elaborazione = int(data[10].get(i))
                P_ora.append(elaborazione)
                elaborazione = int(data[11].get(i))
                P_minuto.append(elaborazione)
                elaborazione = int(data[12].get(i))
                P_secondo.append(elaborazione)
                P_millisecondo.append([data[13].get(i)])

                if(P_flag_primo == 0):
                    P_inizio_ora = int(data[10].get(i))
                    P_inizio_minuto = int(data[11].get(i))
                    P_inizio_secondo = int(data[12].get(i))
                    P_inizio_millisecondo = int(data[13].get(i))
                    P_flag_primo = 1
                else:
                    P_fine_ora = int(data[10].get(i))
                    P_fine_minuto = int(data[11].get(i))
                    P_fine_secondo = int(data[12].get(i))
                    P_fine_millisecondo = int(data[13].get(i))
                
        
        if(data[0].get(i) == IMU1 or data[0].get(i) == IMU2 or data[0].get(i) == IMU3):
            count_IMU = count_IMU + 1
            if(data[2].get(i) == D):
                #dummy message
                dummy_message_IMU = dummy_message_IMU +1
            else:
                I_dev.append([data[0].get(i)])
                I_uno.append([data[1].get(i)])
                I_due.append([data[2].get(i)])
                I_tre.append([data[3].get(i)])
                I_quattro.append([data[4].get(i)])
                I_cinque.append([data[5].get(i)])
                I_sei.append([data[6].get(i)])
                I_sette.append([data[7].get(i)])
                I_giorno.append([data[8].get(i)])
                I_mese.append([data[9].get(i)])
                I_ora.append([data[10].get(i)])
                I_minuto.append([data[11].get(i)])
                I_secondo.append([data[12].get(i)])
                I_millisecondo.append([data[13].get(i)])

                if(I_flag_primo == 0):
                    I_inizio_ora = int(data[10].get(i))
                    I_inizio_minuto = int(data[11].get(i))
                    I_inizio_secondo = int(data[12].get(i))
                    I_inizio_millisecondo = int(data[13].get(i))
                    I_flag_primo = 1
                else:
                    I_fine_ora = int(data[10].get(i))
                    I_fine_minuto = int(data[11].get(i))
                    I_fine_secondo = int(data[12].get(i))
                    I_fine_millisecondo = int(data[13].get(i))
                
            



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
Minuto = pd.DataFrame(E_minuto)
Secondo = pd.DataFrame(E_secondo)
Lat = pd.DataFrame(E_lat)
Long = pd.DataFrame(E_long)

risultatoE = pd.concat([Device,Number,Temperatura,Umidita,Pressione,VOC,CO2,NO2,CO,PM1,PM2P5,PM10,Accel,P1,P2,P3,Data,Ora,Minuto,Secondo,Lat,Long], axis=1)
#SALVATAGGIO DATI SU TXT
np.savetxt(numero_step+'_ENV_'+soggetto_numero+'.txt', risultatoE, fmt='%s')

#PULS = pd.DataFrame(PULSIOSSIMETRO)
P_Device = pd.DataFrame(P_dev)
P_Activity = pd.DataFrame(P_activity)
P_HRs = pd.DataFrame(P_HR)
P_SPO2 = pd.DataFrame(P_SpO2)
P_SCDSTATE = pd.DataFrame(P_SCDstate)
P_GIORNO = pd.DataFrame(P_giorno)
P_MESE = pd.DataFrame(P_mese)
P_ORA = pd.DataFrame(P_ora)
P_MINUTO = pd.DataFrame(P_minuto)
P_SECONDO = pd.DataFrame(P_secondo)
P_MILLISECONDO = pd.DataFrame(P_millisecondo)


risultatoP = pd.concat([P_Device,P_Activity,P_HRs,P_SPO2,P_SCDSTATE,P_GIORNO,P_MESE,P_ORA,P_MINUTO,P_SECONDO,P_MILLISECONDO], axis = 1)
np.savetxt(numero_step+'_PULSE'+soggetto_numero+'.txt', risultatoP, fmt='%s')

#IMUS = pd.DataFrame(IMU)
I_DEV = pd.DataFrame(I_dev)
I_UNO = pd.DataFrame(I_uno)
I_DUE = pd.DataFrame(I_due)
I_TRE = pd.DataFrame(I_tre)
I_QUATTRO = pd.DataFrame(I_quattro)
I_CINQUE = pd.DataFrame(I_cinque)
I_SEI = pd.DataFrame(I_sei)
I_SETTE = pd.DataFrame(I_sette)
I_GIORNO = pd.DataFrame(I_giorno)
I_MESE = pd.DataFrame(I_mese)
I_ORA = pd.DataFrame(I_ora)
I_MINUTO = pd.DataFrame(I_minuto)
I_SECONDO = pd.DataFrame(I_secondo)
I_MILLISECONDO = pd.DataFrame(I_millisecondo)


risultatoI = pd.concat([I_DEV,I_UNO,I_DUE,I_TRE,I_QUATTRO,I_CINQUE,I_SEI,I_SETTE,I_GIORNO,I_MESE,I_ORA,I_MINUTO,I_SECONDO,I_MILLISECONDO], axis = 1)
np.savetxt(numero_step+'_IMU'+soggetto_numero+'.txt', risultatoI, fmt='%s')



print("Il dataset ha", count_environmental, "campioni di Environmental")
print("Il dataset ha", count_pulsossimetro, "campioni di Pulsiossimetro")
print("Il dataset ha", count_IMU, "campioni di IMU")

print("Environmental inizio", E_inizio_ora,":",E_inizio_minuto,":",E_inizio_secondo)
print("Environmental fine", E_fine_ora,":",E_fine_minuto,":",E_fine_secondo)
E_intervallo_tempo = ((E_fine_ora - E_inizio_ora)*60 +(E_fine_minuto-E_inizio_minuto))*60 +(E_fine_secondo-E_inizio_secondo)
print("Environmental dura", E_intervallo_tempo,"secondi, circa ",E_intervallo_tempo/20, "campioni (stima uno ogni 20 secondi)")

print("PulseOxemeter inizio", P_inizio_ora,":",P_inizio_minuto,":",P_inizio_secondo,":",P_inizio_millisecondo)
print("PulseOxemeter fine", P_fine_ora,":",P_fine_minuto,":",P_fine_secondo,":",P_fine_millisecondo)
P_intervallo_tempo = (((P_fine_ora - P_inizio_ora)*60 +(P_fine_minuto-P_inizio_minuto))*60 +(P_fine_secondo-P_inizio_secondo))*1000 + (P_fine_millisecondo-P_inizio_millisecondo)
print("PulseOxemeter dura", P_intervallo_tempo,"millisecondi")

print("IMU inizio", I_inizio_ora,":",I_inizio_minuto,":",I_inizio_secondo,":",I_inizio_millisecondo)
print("IMU fine", I_fine_ora,":",I_fine_minuto,":",I_fine_secondo,":",I_fine_millisecondo)
I_intervallo_tempo = (((I_fine_ora - I_inizio_ora)*60 +(I_fine_minuto-I_inizio_minuto))*60 +(I_fine_secondo-I_inizio_secondo))*1000 + (I_fine_millisecondo-I_inizio_millisecondo)
print("IMU dura", I_intervallo_tempo,"millisecondi")

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
+ "\nData loss IMU: " + str(dataloss_I)+"\n\n"
+ "Environmental inizio  "+ str(E_inizio_ora)+":"+str(E_inizio_minuto)+":"+ str(E_inizio_secondo)
+ "\nEnvironmental fine  "+ str(E_fine_ora) +":"+ str(E_fine_minuto) +":"+ str(E_fine_secondo)
+ "\nEnvironmental dura  "+ str(E_intervallo_tempo) +" secondi\n\n"
+ "PulseOxemeter inizio  "+ str(P_inizio_ora) +":"+ str(P_inizio_minuto) +":"+ str(P_inizio_secondo) +":"+ str(P_inizio_millisecondo)
+ "\nPulseOxemeter fine  "+ str(P_fine_ora) +":"+ str(P_fine_minuto) +":"+ str(P_fine_secondo) +":"+ str(P_fine_millisecondo)
+ "\nPulseOxemeter dura  "+ str(P_intervallo_tempo) +" millisecondi\n\n"
+ "IMU inizio  "+ str(I_inizio_ora) +":"+ str(I_inizio_minuto) +":"+ str(I_inizio_secondo) +":"+ str(I_inizio_millisecondo)
+ "\nIMU fine  "+ str(I_fine_ora) +":"+ str(I_fine_minuto) +":"+ str(I_fine_secondo)+ ":"+ str(I_fine_millisecondo)
+ "\nIMU dura  "+ str(I_intervallo_tempo) +" millisecondi")
