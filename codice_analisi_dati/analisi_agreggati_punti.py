from scipy import stats
from scipy.stats import f_oneway
import scikit_posthocs as sp
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

data = pd.read_csv("dati_aggregati_punti.txt", sep="\t", header=None, engine='python')


x = [0.5,1.5,2.5,3.5,4.5,5.5,6.5]           #variabili usate per i grafici di heatmap
a =['A', 'B' ,'C', 'D', 'E', 'F', 'G']      #non usarle per altro

########    CONFRONTO STATISTICO SUI DATI AGGREGATI PER OGNI INQUINANTE TRA I DIVERSI PUNTI DI ACQUISIZIONE STATICA    ############
# suddivisioned delle colonne del txt:
#   0 -> tVOC    
#   1 -> CO2
#   2 -> CO
#   3 -> NO2
#   4 -> PM1.0
#   5 -> PM2.5
#   6 -> PM10
#
# I primi valori si riferiscono all'acquisizione nel punto A, 
# mentre per le acquisizioni nei punti successivi bisogna aggiungere un multiplo di 8 per ogni acquisizione fissa
selezione = [0,1,4,5,6]
f = open("Friedman_test_result_punti.txt", "a")
f.write("Confronto tra i dati aggregati degli inquinanti nei diversi punti di acquisizione statica\n"+
"\n\nPrima un test di Shapiro-Wilk per valutare eventuale distribuzione normale dei dati\n")
f.write("Risultati del test sono:\n")
f.close

risultato = []
ris_parz = []
count = 0
for j in range(0,7):
    for i in range(0,5):
        res = stats.shapiro(data[(0 + 8*j)+selezione[i]])
        #print(j,a[i])
        #print(res)
        f = open("Friedman_test_result_punti.txt", "a")
        f.write(str(j) + "-"+str(selezione[i]) + ": " +str(res) + "\n")
        f.close
        if (res.pvalue > 0.05):
            count = count + 1
            #print("campione non normale")

if (count != 0):
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nCi sono "+str(count)+" campioni con distribuzioni non normali, secondo il Test di Shapiro-Wilk\n")
    f.close

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\n Test di Friedman su i campioni per i diversi inquinanti:\n")
f.close
        

print("Analisi statistica sui dati aggregati di tVOC")
res_VOC = stats.friedmanchisquare(data[0], data[8], data[16], data[24], data[32], data[40], data[48])
print(res_VOC)
f = open("Friedman_test_result_punti.txt", "a")
f.write("\ntVOC results: "+ str(res_VOC))
f.close
if (res_VOC.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataVOC = np.array([data[0], data[8], data[16], data[24], data[32], data[40], data[48]])
    res = sp.posthoc_nemenyi_friedman(dataVOC.T)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0.05), annot=res ,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    x = [0.5,1.5,2.5,3.5,4.5,5.5,6.5]           #variabili usate per i grafici di heatmap
    a =['A', 'B' ,'C', 'D', 'E', 'F', 'G']      #non usarle per altro
    plt.xticks(x,a)
    plt.yticks(x,a)
    #plt.show()
    plt.title("tVOC posthoc Nemenyi test result ")
    plt.savefig("Heat map tVOC.png")
    plt.clf()
    res = 0



print("Analisi statistica sui dati aggregati di CO2")
res_CO2 = stats.friedmanchisquare(data[1], data[9], data[17], data[25], data[33], data[41], data[49])
print(res_CO2)
f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nCO2 results: "+ str(res_CO2))
f.close
if (res_CO2.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataCO2 = np.array([data[1], data[9], data[17], data[25], data[33], data[41], data[49]])
    res = sp.posthoc_nemenyi_friedman(dataCO2.T)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0.05),annot=res,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    plt.xticks(x,a)
    plt.yticks(x,a)
    plt.title("CO$_{2}$ posthoc Nemenyi test result ")
    #plt.show()
    plt.savefig("Heat map CO2.png")
    res = 0
    plt.clf()


print("Analisi statistica sui dati aggregati di PM1.0")
res_PM1 = stats.friedmanchisquare(data[4], data[12], data[20], data[28], data[36], data[44], data[52])
print(res_PM1)
f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM1.0 results: "+ str(res_PM1))
f.close
if (res_PM1.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataPM1 = np.array([data[4], data[12], data[20], data[28], data[36], data[44], data[52]])
    res = sp.posthoc_nemenyi_friedman(dataPM1.T)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0.05),annot=res,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    plt.xticks(x,a)
    plt.yticks(x,a)
    plt.title("PM1.0 posthoc Nemenyi test result ")
    #plt.show()
    plt.savefig("Heat map PM1.0.png")
    res = 0
    plt.clf()


print("Analisi statistica sui dati aggregati di PM2.5")
res_PM2 = stats.friedmanchisquare(data[5], data[13], data[21], data[29], data[37], data[45], data[53])
print(res_PM2)
f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM2.5 results: "+ str(res_PM2))
f.close
if (res_PM2.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataPM2 = np.array([data[5], data[13], data[21], data[29], data[37], data[45], data[53]])
    res = sp.posthoc_nemenyi_friedman(dataPM2.T)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0.05),annot=res,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    plt.xticks(x,a)
    plt.yticks(x,a)
    plt.title("PM2.5 posthoc Nemenyi test result ")
    #plt.show()
    plt.savefig("Heat map PM2.5.png")
    res = 0
    plt.clf()



print("Analisi statistica sui dati aggregati di PM10")
res_PM10 = stats.friedmanchisquare(data[6], data[14], data[22], data[30], data[38], data[46], data[54])
print(res_PM10)
f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM10 results: "+ str(res_PM10))
f.close
if (res_PM10.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataPM10 = np.array([data[6], data[14], data[22], data[30], data[38], data[46], data[54]])
    res = sp.posthoc_nemenyi_friedman(dataPM10.T)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0.05),annot=res,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    plt.xticks(x,a)
    plt.yticks(x,a)
    plt.title("PM10 posthoc Nemenyi test result ")
    #plt.show()
    plt.savefig("Heat map PM10.png")
    res = 0
    plt.clf()

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nFine dell'analisi sui dati aggregati per il confronto tra i punti di acquisizione statica\n\nCalcolo dei quartili delle varie distribuzioni\n\n")
f.close


################# BOXPLOT e CALCOLI ANNESSI

####### tVOC boxplot ################
VOC = [data[0], data[8], data[16], data[24], data[32], data[40], data[48]]
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
plt.boxplot(VOC)
#ax1.boxplot(data_B)
plt.xticks(x,values)
plt.ylim(bottom = 0,top = 1700)
plt.title("tVOC Boxplot")
plt.savefig("tVOC Boxplot.png")
plt.show()
print("boxplot tVOC")

f = open("Friedman_test_result_punti.txt", "a")
f.write("\ntVOC:\n")
f.close
for i in range (0,7):
    q75, q50, q25 = np.percentile(data[8*i], [75, 50 ,25])
    IQR = round(q75 - q25,2)
    print(q50)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nMedian: "+str(q50)+" IRQ: "+str(IQR))
    f.close
####### CO2 boxplot ################
plt.figure(2)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
CO2 = [data[1], data[9], data[17], data[25], data[33], data[41], data[49]]
plt.boxplot(CO2)
plt.xticks(x,values)
plt.title("CO$_{2}$ Boxplot")
plt.ylim(bottom = 0,top = 1700)
plt.savefig("CO2 Boxplot.png")
plt.show()
print("boxplot CO2")

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nCO2:\n")
f.close
for i in range (0,7):
    q75, q50, q25 = np.percentile(data[1 + 8*i], [75, 50 ,25])
    IQR = round(q75 - q25,2)
    print(q50)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nMedian: "+str(q50)+" IRQ: "+str(IQR))
    f.close

####### PM1.0 boxplot ################
plt.figure(3)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM1 = [data[4], data[12], data[20], data[28], data[36], data[44], data[52]]
plt.boxplot(PM1)
plt.xticks(x,values)
plt.ylim(bottom = 0,top = 100)
plt.title("PM1.0 Boxplot")
plt.savefig("PM1.0 Boxplot.png")
plt.show()
print("boxplot PM1.0")

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM1.0:\n")
f.close
for i in range (0,7):
    q75, q50, q25 = np.percentile(data[4 + 8*i], [75, 50 ,25])
    IQR = round(q75 - q25,2)
    print(q50)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nMedian: "+str(q50)+" IRQ: "+str(IQR))
    f.close

####### PM2.5 boxplot ################
plt.figure(4)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM2p5 = [data[5], data[13], data[21], data[29], data[37], data[45], data[53]]
plt.boxplot(PM2p5)
plt.xticks(x,values)
plt.ylim(bottom = 0,top = 100)
plt.title("PM2.5 Boxplot")
plt.savefig("PM2.5 Boxplot.png")
plt.show()
print("boxplot PM2.5")

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM2.5:\n")
f.close
for i in range (0,7):
    q75, q50, q25 = np.percentile(data[5 + 8*i], [75, 50 ,25])
    IQR = round(q75 - q25,2)
    print(q50)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nMedian: "+str(q50)+" IRQ: "+str(IQR))
    f.close

####### PM10 boxplot ################
plt.figure(5)
x = [1,2,3,4,5,6,7]
values = ['A', 'B', 'C', 'D', 'E', 'F', 'G'] 
PM10 = [data[6], data[14], data[22], data[30], data[38], data[46], data[54]]
plt.boxplot(PM10)
plt.xticks(x,values)
plt.ylim(bottom = 0,top = 100)
plt.title("PM10 Boxplot")
plt.savefig("PM10 Boxplot.png")
plt.show()
print("boxplot PM10")

f = open("Friedman_test_result_punti.txt", "a")
f.write("\n\nPM10:\n")
f.close
for i in range (0,7):
    q75, q50, q25 = np.percentile(data[6 + 8*i], [75, 50 ,25])
    IQR = round(q75 - q25,2)
    print(q50)
    f = open("Friedman_test_result_punti.txt", "a")
    f.write("\nMedian: "+str(q50)+" IRQ: "+str(IQR))
    f.close