import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

filename = 'Bland-Altman.txt'       #Inserire nome del file di Environmental Monitor

righe_da_saltare = 1   #inserire numero di riga in cui c'è scritta start

data = pd.read_csv(filename, sep="\t", header=None, engine='python', skiprows=righe_da_saltare)
print(data)
length = len(data)
print("Il dataset ha", length, "campioni")

#dati presenti nel seguente ordine:
# 0 -> temperature      10 -> temperatura
# 1 -> umidità          11 -> umidità
# 2 -> PM2.5            12 -> pressione
# 3 -> VOC              13 -> VOC
# 4 -> CO2              14 -> CO2
# 6 -> Pressure         18 -> PM2.5
A = []
B = []
F = []

for i in range (0,18):
    data[i] = data[i].astype(float)
uHoo = [4,3,2,0,1,6]
EM =[14,13,18,10,11,12]
tipo = ["CO$_{2}$","tVOC","PM2.5","Temperature", "Humidity","Pressure"]
######################################## BLAND ALTMAN


##################################### CO2
diffs_CO2 = []
means_CO2 = []
for i in range (0,length):
    diffs_CO2.append([data[4].get(i) - data[14].get(i)])
    means_CO2.append([(data[4].get(i) + data[14].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_CO2)
# Sample standard deviation
sd = np.std(diffs_CO2, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'CO$_{2}$ Bland-Altman Plot',
    xlabel='Mean [ppm]', ylabel='Difference [ppm]'
)
# Scatter plot
ax.scatter(means_CO2, diffs_CO2, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()

########################   TVOC
bias = 0
sd = 0
diffs_VOC = []
means_VOC = []
for i in range (0,length):
    diffs_VOC.append([data[3].get(i) - data[13].get(i)])
    means_VOC.append([(data[3].get(i) + data[13].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_VOC)
# Sample standard deviation
sd = np.std(diffs_VOC, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'tVOC Bland-Altman Plot',
    xlabel='Mean [ppb]', ylabel='Difference [ppb]'
)
# Scatter plot
ax.scatter(means_VOC, diffs_VOC, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()


########################   Temperature
bias = 0
sd = 0
diffs_T = []
means_T = []
for i in range (0,length):
    diffs_T.append([data[0].get(i) - data[10].get(i)])
    means_T.append([(data[0].get(i) + data[10].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_T)
# Sample standard deviation
sd = np.std(diffs_T, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'Temperature Bland-Altman Plot',
    xlabel='Mean [°C]', ylabel='Difference [°C]'
)
# Scatter plot
ax.scatter(means_T, diffs_T, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()



########################   HUMIDITY
bias = 0
sd = 0
diffs_U = []
means_U = []
for i in range (0,length):
    diffs_U.append([data[1].get(i) - data[11].get(i)])
    means_U.append([(data[1].get(i) + data[11].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_U)
# Sample standard deviation
sd = np.std(diffs_U, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'Humidity Bland-Altman Plot',
    xlabel='Mean [%]', ylabel='Difference [%]'
)
# Scatter plot
ax.scatter(means_U, diffs_U, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()


########################   PRESSURE
bias = 0
sd = 0
diffs_P = []
means_P = []
for i in range (0,length):
    diffs_P.append([data[6].get(i) - data[12].get(i)])
    means_P.append([(data[6].get(i) + data[12].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_P)
# Sample standard deviation
sd = np.std(diffs_P, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'Pressure Bland-Altman Plot',
    xlabel='Mean [Pa]', ylabel='Difference [Pa]'
)
# Scatter plot
ax.scatter(means_P, diffs_P, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()


########################   PM2.5
bias = 0
sd = 0
diffs_PM = []
means_PM = []
for i in range (0,length):
    diffs_PM.append([data[2].get(i) - data[18].get(i)])
    means_PM.append([(data[2].get(i) + data[18].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_PM)
# Sample standard deviation
sd = np.std(diffs_PM, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'PM2.5 Bland-Altman Plot',
    xlabel='Mean [μg/m$^{3}$]', ylabel='Difference [μg/m$^{3}$]'
)
# Scatter plot
ax.scatter(means_PM, diffs_PM, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1.1, max_y * 1.1)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()


########################   PRESSURE
bias = 0
sd = 0
diffs_P = []
means_P = []
for i in range (0,length):
    diffs_P.append([data[6].get(i) - data[12].get(i)])
    means_P.append([(data[6].get(i) + data[12].get(i))/2])

# Average difference (aka the bias)
bias = np.mean(diffs_P)
# Sample standard deviation
sd = np.std(diffs_P, ddof=1)

upper_loa = bias + 2 * sd
lower_loa = bias - 2 * sd

ax = plt.axes()
ax.set(
    title= 'Pressure Bland-Altman Plot',
    xlabel='Mean [Pa]', ylabel='Difference [Pa]'
)
# Scatter plot
ax.scatter(means_P, diffs_P, c='k', s=20, alpha=0.6, marker='o')
# Plot the zero line
ax.axhline(y=0, c='k', lw=0.5)
# Plot the bias and the limits of agreement
ax.axhline(y=upper_loa, c='grey', ls='--')
ax.axhline(y=bias, c='grey', ls='--')
ax.axhline(y=lower_loa, c='grey', ls='--')
# Get axis limits
left, right = plt.xlim()
bottom, top = plt.ylim()
# Set y-axis limits
max_y = max(abs(bottom), abs(top))
ax.set_ylim(-max_y * 1, -max_y * 0.8)
# Set x-axis limits
domain = right - left
ax.set_xlim(left, left + domain * 1.1)
# Add the annotations
ax.annotate('+2×SD', (right, upper_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{upper_loa:+4.2f}', (right, upper_loa), (0, -25), textcoords='offset pixels')
ax.annotate('Bias', (right, bias), (0, 7), textcoords='offset pixels')
ax.annotate(f'{bias:+4.2f}', (right, bias), (0, -25), textcoords='offset pixels')
ax.annotate('-2×SD', (right, lower_loa), (0, 7), textcoords='offset pixels')
ax.annotate(f'{lower_loa:+4.2f}', (right, lower_loa), (0, -25), textcoords='offset pixels')
plt.show()