import matplotlib.pyplot as plt
import numpy as np
import sys
from definition_plots import convergence_plot, ffvs2nd_plot

B0MHz_str = sys.argv[1]
T_str = sys.argv[2]
outfolder = sys.argv[3]

data_convergence = f"{outfolder}/data_convergence_gridsize_{B0MHz_str}_{T_str}_lebedev"
data_ffvs2nd = f"{outfolder}/data_finitefieldvs2ndorder_{T_str}"

fig, axes = plt.subplots(1, 2, figsize = (6,3))
convergence_plot(axes[0], data_convergence)
ffvs2nd_plot(axes[1], data_ffvs2nd)
plt.tight_layout()
plt.savefig(f"{outfolder}/finitefield_subplots_{B0MHz_str}_{T_str}.png", dpi=300)

