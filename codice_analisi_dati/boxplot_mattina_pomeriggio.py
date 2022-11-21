globals().clear()

# PARAMETERS SELECTION
filename = 'confronto_mat_pome.txt'

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


M_VOC = []
M_CO2 = [] 
M_PM1p0 = [] 
M_PM2p5 = [] 
M_PM10 = []
P_VOC = [] 
P_CO2 = [] 
P_PM1p0 = [] 
P_PM2p5 = []
P_PM10 = []



######################################
# LETTURA DEL FILE CONTENENTE I DATI #
######################################
data = pd.read_csv(filename, sep="\t", header=None, engine='python')
length = len(data)
print("Il dataset ha", length, "campioni")
print(data)
for i in range(0, length):
    M_VOC.append([data[0].get(i)])
    M_CO2.append([data[1].get(i)])
    M_PM1p0.append([data[4].get(i)])
    M_PM2p5.append([data[5].get(i)])
    M_PM10.append([data[6].get(i)])
    P_VOC.append([data[7].get(i)])
    P_CO2.append([data[8].get(i)])
    P_PM1p0.append([data[11].get(i)])
    P_PM2p5.append([data[12].get(i)])
    P_PM10.append([data[13].get(i)])



####### tVOC boxplot ################
VOC_data_M = np.concatenate((M_VOC))
VOC_data_P = np.concatenate((P_VOC))


fig1, ax1 = plt.subplots()
x = [1,2]
values = ['Morning', 'Afternoon'] 
VOC = [VOC_data_M,VOC_data_P]
plt.boxplot(VOC)
#ax1.boxplot(data_B)
plt.ylim(bottom = 0,top = 1700)
plt.xticks(x,values)
plt.title("tVOC Boxplot")
#plt.show()
plt.savefig("boxplot tVOC.png")
plt.clf()
print("boxplot tVOC")

####### CO2 boxplot ################
CO2_data_M = np.concatenate((M_CO2))
CO2_data_P = np.concatenate((P_CO2))
plt.figure(2)
x = [1,2]
values = ['Morning', 'Afternoon'] 
CO2 = [CO2_data_M,CO2_data_P]
plt.boxplot(CO2)
plt.ylim(bottom = 0,top = 1700)
plt.xticks(x,values)
plt.title("CO$_{2}$ Boxplot")
#plt.show()
plt.savefig("boxplot CO2.png")
plt.clf()
print("boxplot CO2")

####### PM1.0 boxplot ################
PM1_data_M = np.concatenate((M_PM1p0))
PM1_data_P = np.concatenate((P_PM1p0))
x = [1,2]
values = ['Morning', 'Afternoon'] 
PM1 = [PM1_data_M,PM1_data_P]
plt.boxplot(PM1)
plt.ylim(bottom = 0,top = 100)
plt.xticks(x,values)
plt.title("PM1.0 Boxplot")
#plt.show()
plt.savefig("boxplot PM1.png")
plt.clf()
print("boxplot PM1.0")

####### PM2.5 boxplot ################
PM2p5_data_M = np.concatenate((M_PM2p5))
PM2p5_data_P = np.concatenate((P_PM2p5))

plt.figure(4)
x = [1,2]
values = ['Morning', 'Afternoon'] 
PM2p5 = [PM2p5_data_M,PM2p5_data_P]
plt.boxplot(PM2p5)
plt.ylim(bottom = 0,top = 100)
plt.xticks(x,values)
plt.title("PM2.5 Boxplot")
#plt.show()
plt.savefig("boxplot PM2.png")
plt.clf()
print("boxplot PM2.5")

####### PM10 boxplot ################
PM10_data_M = np.concatenate((M_PM10))
PM10_data_P = np.concatenate((P_PM10))
plt.figure(5)
x = [1,2]
values = ['Morning', 'Afternoon'] 
PM10 = [PM10_data_M,PM10_data_P]
plt.boxplot(PM10)
plt.ylim(bottom = 0,top = 100)
plt.xticks(x,values)
plt.title("PM10 Boxplot")
#plt.show()
plt.savefig("boxplot PM10.png")
plt.clf()
print("boxplot PM10")
