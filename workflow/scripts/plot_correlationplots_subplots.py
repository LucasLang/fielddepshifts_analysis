import matplotlib.pyplot as plt
import numpy as np

def left_plot(ax):
    exp = np.loadtxt('expshift_nisalhdpt_wolabels.txt')
    calc = np.loadtxt('calc_shifts')

    exp400 = exp[:, 0]
    calc400 = calc[:, 0]

    interval = [-400, 500]

    ax.plot(interval, interval, color='grey', zorder=1)
    ax.scatter(exp400, calc400, facecolors='tab:blue', edgecolors='black', zorder=2)
    ax.set_xlim(*interval)
    ax.set_ylim(*interval)
    ax.set_xlabel(r"$\delta_\mathrm{exp}$(400 MHz) / ppm")
    ax.set_ylabel(r"$\delta_\mathrm{calc}$(400 MHz) / ppm")

def right_plot(ax):
    exp = np.loadtxt('expshift_nisalhdpt_wolabels.txt')
    calc = np.loadtxt('calc_shifts')

    exp_diff = exp[:, 1] - exp[:, 0]
    calc_diff = calc[:, 1] - calc[:, 0]

    interval = [-1.5, 1.5]

    ax.plot(interval, interval, color='grey', zorder=1)
    ax.scatter(exp_diff, calc_diff, facecolors='tab:blue', edgecolors='black', zorder=2)
    ax.set_xlim(*interval)
    ax.set_ylim(*interval)
    ax.set_xlabel(r"$\Delta\delta_\mathrm{exp}$(1.2 GHz − 400 MHz) / ppm")
    ax.set_ylabel(r"$\Delta\delta_\mathrm{calc}$(1.2 GHz − 400 MHz) / ppm")

fig, axes = plt.subplots(1, 2, figsize = (6,3))
left_plot(axes[0])
right_plot(axes[1])
plt.tight_layout()
plt.savefig("correlationplots_subplots.png", dpi=300)
