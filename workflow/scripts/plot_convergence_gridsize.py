import matplotlib.pyplot as plt
import numpy as np
import sys
from definition_convergence_plot import convergence_plot

B0MHz_str = sys.argv[1]
B0MHz = float(B0MHz_str)
T_str = sys.argv[2]
T = float(T_str)
gridtype = sys.argv[3]
outfolder = sys.argv[4]

data_convergence = f"{outfolder}/data_convergence_gridsize_{B0MHz_str}_{T_str}_{gridtype}"

fig, ax = plt.subplots()
convergence_plot(ax, data_convergence)
plt.savefig(f"{outfolder}/convergence_gridsize_{B0MHz_str}_{T_str}_{gridtype}.png", dpi=300)
