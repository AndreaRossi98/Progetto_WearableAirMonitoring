globals().clear()

# Questo codice serve a creare boxplot di confronto tra i vari punti di acquisizione statica per la media della frequenza respiratoria. 
# I dati di tutti i soggetti sono considerati, mediati al minuto

# PARAMETERS SELECTION
filename = 'freq_resp_confronto.txt'


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


f_1_A = []
f_1_B = []
f_1_C = []
f_1_D = []
f_1_E = []
f_1_F = []
f_1_G = []
f_2 = []
f_3 = []
f_4 = []
f_5 = []
f_6 = []
f_7 = []



######################################
# LETTURA DEI FILE CONTENENTE I DATI #
######################################


data = pd.read_csv(filename, sep="\t", header=None, engine='python',skiprows=1)
length = len(data)
print("Il dataset ha", length, "campioni")
print(data)
for j in range(0, 7):
    for i in range(0, length):
        if (i<5):
            f_1_A.append([data[j].get(i)])
        else:
            if (i>4 and i<10):
                f_1_B.append([data[j].get(i)])
            else:
                if(i>9 and i<15):
                    f_1_C.append([data[j].get(i)])
                else:
                    if(i>14 and i<20):
                        f_1_D.append([data[j].get(i)])
                    else:
                        if(i>19 and i<25):
                            f_1_E.append([data[j].get(i)])
                        else:
                            if(i>24 and i<30):
                                f_1_F.append([data[j].get(i)])
                            else:
                                if(i>29 and i<35):
                                    f_1_G.append([data[j].get(i)])

    ####### tVOC boxplot ################
    freq_A = np.concatenate((f_1_A))
    freq_B = np.concatenate((f_1_B))
    freq_C = np.concatenate((f_1_C))
    freq_D = np.concatenate((f_1_D))
    freq_E = np.concatenate((f_1_E))
    freq_F = np.concatenate((f_1_F))
    freq_G = np.concatenate((f_1_G))

    fig1, ax1 = plt.subplots()
    x = [1,2,3,4,5,6,7]
    values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
    FREQ = [freq_A,freq_B,freq_C,freq_D,freq_E,freq_F,freq_G]
    plt.boxplot(FREQ)

    plt.xticks(x,values)
    plt.title("Breathing frequency Boxplot subject"+ str(j+1))
    plt.show()
    print("boxplot breath")