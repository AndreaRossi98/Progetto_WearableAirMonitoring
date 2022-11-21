from scipy import stats
from scipy.stats import f_oneway
import matplotlib.pyplot as plt
import pandas as pd
# PARAMETERS SELECTION
filename = 'confronto_mat_pome.txt'

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

########################### FILE DA CUI PRENDERE I DATI
# Divisione delle colonne:
# 0 -> tVOC mattina         7 -> tVOC pomeriggio
# 1 -> CO2 mattina          8 -> CO2 pomeriggio
# 4 -> PM1.0 mattina        9 -> PM1.0 pomeriggio
# 5 -> PM2.5 mattina        10 -> PM2.5 pomeriggio
# 6 -> PM10 mattina         11 -> PM10 pomeriggio


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
    P_PM1p0.append([data[9].get(i)])
    P_PM2p5.append([data[10].get(i)])
    P_PM10.append([data[11].get(i)])

f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("Confronto tra i dati aggregati degli inquinanti nei diversi punti tra mattina e pomeriggio\n"+
"\n\nPrima un test di Shapiro-Wilk per valutare eventuale distribuzione normale dei dati\n")
f.write("Risultati del test sono:\n")
f.close

count = 0
res = stats.shapiro(M_VOC)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n M_VOC: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(P_VOC)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n P_VOC: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(M_CO2)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n M_CO2: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(P_CO2)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n P_CO2: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(M_PM1p0)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n M_PM1: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(P_PM1p0)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n P_PM1: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(M_PM2p5)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n M_PM2.5: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(P_PM2p5)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n P_PM2p5: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(M_PM10)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n M_PM10: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

res = stats.shapiro(P_PM10)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\n P_PM10: "+ str(res))
f.close
if (res.pvalue > 0.05):
    count = count + 1
    #print("campione non normale")

if (count != 0):
    f = open("Wilcoxon_test_result_matt_pome.txt", "a")
    f.write("\n\nCi sono "+str(count)+" campioni con distribuzioni non normali, secondo il Test di Shapiro-Wilk\n")
    f.close

print("Confronto tVOC")
res=stats.wilcoxon(M_VOC, P_VOC)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\ntVOC results: "+ str(res))
f.close

print("Confronto CO2")
res=stats.wilcoxon(M_CO2, P_CO2)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\nCO2 results: "+ str(res))
f.close

print("Confronto PM1")
res=stats.wilcoxon(M_PM1p0, P_PM1p0)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\nPM1.0 results: "+ str(res))
f.close

print("Confronto PM2.5")
res=stats.wilcoxon(M_PM2p5, P_PM2p5)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\nPM2.5 results: "+ str(res))
f.close

print("Confronto PM10")
res=stats.wilcoxon(M_PM10, P_PM10)
print(res)
f = open("Wilcoxon_test_result_matt_pome.txt", "a")
f.write("\nPM10 results: "+ str(res))
f.close

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nFine dell'analisi sui dati aggregati per il confronto tra i punti di acquisizione statica")
f.close