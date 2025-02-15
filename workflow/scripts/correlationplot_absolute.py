import matplotlib.pyplot as plt
import numpy as np

exp = np.loadtxt('expshift_nisalhdpt_wolabels.txt')
calc = np.loadtxt('calc_shifts')

exp400 = exp[:, 0]
calc400 = calc[:, 0]

interval = [-400, 500]

plt.plot(interval, interval, color='grey', zorder=1)
plt.scatter(exp400, calc400, facecolors='tab:blue', edgecolors='black', zorder=2)
plt.xlim(*interval)
plt.ylim(*interval)
plt.xlabel(r"$\delta_\mathrm{exp}$(400 MHz)")
plt.ylabel(r"$\delta_\mathrm{calc}$(400 MHz)")

plt.savefig("correlationplot_absolute.png", dpi=300)
