from scipy import stats
from scipy.stats import f_oneway
import scikit_posthocs as sp
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

data = pd.read_csv("dati_aggregati_freq.txt", sep="\t", header=None, engine='python',skiprows=1)

########    CONFRONTO STATISTICO SUI DATI AGGREGATI PER FREQUENZA RESPIRATORIA TRA I DIVERSI PUNTI DI ACQUISIZIONE STATICA    ############
# suddivisioned delle colonne del txt:
#   0 -> A   
#   1 -> B
#   2 -> C
#   3 -> D
#   4 -> E
#   5 -> F
#   6 -> G
#

f = open("Friedman_test_result_freq_respi.txt", "a")
f.write("Confronto tra i dati aggregati della frequenaz respiratoria nei diversi punti di acquisizione statica\n"+
"\n\nPrima un test di Shapiro-Wilk per valutare eventuale distribuzione normale dei dati\n")
f.write("Risultati del test sono:\n")
f.close

risultato = []
ris_parz = []
count = 0

for i in range(0,7):
    res = stats.shapiro(data[i])
    #print(res)
    f = open("Friedman_test_result_freq_respi.txt", "a")
    f.write(str(i) + ": " +str(res) + "\n")
    f.close
    if (res.pvalue > 0.05):
        count = count + 1
        #print("campione non normale")

if (count != 0):
    f = open("Friedman_test_result_freq_respi.txt", "a")
    f.write("\nCi sono "+str(count)+" campioni con distribuzioni non normali, secondo il Test di Shapiro-Wilk\n")
    f.close

f = open("Friedman_test_result_freq_respi.txt", "a")
f.write("\n\n Test di friedman su i campioni di frequenza respiratoria per i diversi inquinanti:\n")
f.close
        

print("Analisi statistica sui dati aggregati di frequenza respiratoria")
res = stats.friedmanchisquare(data[0], data[1], data[2], data[3], data[4], data[5], data[6])
print(res)
f = open("Friedman_test_result_freq_respi.txt", "a")
f.write("\nresults: "+ str(res))
f.close
if (res.pvalue < 0.05): #in caso, eseguo un test posthoc Nemenyi di multicomparazione
    dataFreq = np.array([data[0], data[1], data[2], data[3], data[4], data[5], data[6]])
    res = sp.posthoc_nemenyi_friedman(dataFreq.T)
    f = open("Friedman_test_result_freq_respi.txt", "a")
    f.write("\nRisultato posthoc Nemenyi test: \n"+ str(res))
    f.close
    plt.clf()
    b = sns.heatmap((res>0),annot=res,fmt=".2",cmap='RdYlGn',linewidths=0.30,cbar=False)
    x = [0.5,1.5,2.5,3.5,4.5,5.5,6.5]           #variabili usate per i grafici di heatmap
    a =['A', 'B' ,'C', 'D', 'E', 'F', 'G']      #non usarle per altro
    plt.xticks(x,a)
    plt.yticks(x,a)
    plt.title("Breath frequency posthoc Nemenyi test result ")
    plt.savefig("Heat map Breath frequency.png")
    plt.show()
    plt.clf()
    res = 0





f = open("Friedman_test_result_freq_respi.txt", "a")
f.write("\n\nFine dell'analisi sui dati aggregati per il confronto tra i punti di acquisizione statica")
f.close