import matplotlib.pyplot as plt
import numpy as np
import sys
from definition_convergence_plot import convergence_plot

B0MHz_str = sys.argv[1]
B0MHz = float(B0MHz_str)
T_str = sys.argv[2]
T = float(T_str)
outfolder = sys.argv[3]

data_convergence = f"{outfolder}/data_convergence_gridsize_{B0MHz_str}_{T_str}_lebedev"
data_ffvs2nd = f"{outfolder}/data_finitefieldvs2ndorder_{T_str}"

def right_plot(ax, data_ffvs2nd):
    data = np.loadtxt(data_ffvs2nd)
    B0_MHz = data[:,0]
    mean = data[:,1]
    min = data[:,2]
    max = data[:,3]

    ax.plot(B0_MHz, mean, label="mean")
    ax.fill_between(B0_MHz, max, min, alpha=0.2, label="min to max")
    ax.set_yscale("log")
    ax.set_xscale("log")
    ax.set_xlim(B0_MHz[0], B0_MHz[-1])
    ax.set_xlabel("Proton Larmor frequency / MHz")
    ax.set_ylabel("Deviation relative to finite field")
    ax.legend()

fig, axes = plt.subplots(1, 2, figsize = (6,3))
convergence_plot(axes[0], data_convergence)
right_plot(axes[1], data_ffvs2nd)
plt.tight_layout()
plt.savefig(f"{outfolder}/finitefield_subplots_{B0MHz_str}_{T_str}.png", dpi=300)

