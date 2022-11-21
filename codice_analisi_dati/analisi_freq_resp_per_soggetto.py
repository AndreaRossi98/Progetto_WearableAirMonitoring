globals().clear()

# Questo codice serve a creare boxplot di confronto tra i vari punti di acquisizione statica per la media della frequenza respiratoria. 
# I dati di tutti i soggetti sono considerati, mediati al minuto

# PARAMETERS SELECTION
filename = 'dati_freq_soggetto.txt'


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


#aggiungere ogni volta una lista per il nuovo soggetto e aggiornare il numero totale di soggetti presenti

f_1 = []
f_2 = []
f_3 = []
f_4 = []
f_5 = []
f_6 = []
f_7 = []

numero_soggetti = 7

data = pd.read_csv(filename, sep="\t", header=None, engine='python',skiprows=1)
length = len(data)
print("Il dataset ha", length, "campioni")

f = open("Friedman_test_result_breathfrequency_soggetti.txt", "a")
f.write("Confronto tra i dati aggregati della frequenza respiratoria dei diversi soggetti aggregati per punti di acquisizione statica\n"+
"\n\nPrima un test di Shapiro-Wilk per valutare eventuale distribuzione normale dei dati\n")
f.write("Risultati del test sono:\n")
f.close

for i in range(0,numero_soggetti):
    res = stats.shapiro(data[i])
    print(res)
    f = open("Friedman_test_result_breathfrequency_soggetti.txt", "a")
    f.write("Soggetto S"+str(i+1) +  ": " +str(res) + "\n")
    f.close
    if(res.pvalue <0.05):
        print("Distribuzione non normale")

for i in range(0, length):
    f_1.append([data[0].get(i)])
    f_2.append([data[1].get(i)])
    f_3.append([data[2].get(i)])
    f_4.append([data[3].get(i)])
    f_5.append([data[4].get(i)])
    f_6.append([data[5].get(i)])
    f_7.append([data[6].get(i)])

freq_1 = np.concatenate((f_1))
freq_2 = np.concatenate((f_2))
freq_3 = np.concatenate((f_3))
freq_4 = np.concatenate((f_4))
freq_5 = np.concatenate((f_5))
freq_6 = np.concatenate((f_6))
freq_7 = np.concatenate((f_7))

x = [1,2,3,4,5,6,7]
values = ['S01', 'S02', 'S03', 'S04', 'S05', 'S06', 'S07'] 

freq = [freq_1,freq_2,freq_3,freq_4,freq_5,freq_6,freq_7]
plt.boxplot(freq)
plt.xticks(x,values)
plt.title("Breaths frequency Boxplot")
plt.savefig("Boxplot_freq_soggetto.png")
plt.show()

print("Analisi statistica sui dati aggregati di Respiratory frequencies")
res = stats.friedmanchisquare(freq_1,freq_2,freq_3,freq_4,freq_5,freq_6,freq_7)
print(res)
f = open("Friedman_test_result_breathfrequency_soggetti.txt", "a")
f.write("\n\nTest di Friedman:\n" + str(res))
f.close

f = open("Friedman_test_result_breathfrequency_soggetti.txt", "a")
f.write("\n\nAnalisi finita\n")
f.close