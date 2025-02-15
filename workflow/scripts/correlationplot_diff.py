import matplotlib.pyplot as plt
import numpy as np

exp = np.loadtxt('expshift_nisalhdpt_wolabels.txt')
calc = np.loadtxt('calc_shifts')

exp_diff = exp[:, 1] - exp[:, 0]
calc_diff = calc[:, 1] - calc[:, 0]

interval = [-1.5, 1.5]

plt.plot(interval, interval, color='grey', zorder=1)
plt.scatter(exp_diff, calc_diff, facecolors='tab:blue', edgecolors='black', zorder=2)
plt.xlim(*interval)
plt.ylim(*interval)
plt.xlabel(r"$\delta_\mathrm{exp}$(1.2 GHz)$-\delta_\mathrm{exp}$(400 MHz)")
plt.ylabel(r"$\delta_\mathrm{calc}$(1.2 GHz)$-\delta_\mathrm{calc}$(400 MHz)")

plt.savefig("correlationplot_diff.png", dpi=300)
