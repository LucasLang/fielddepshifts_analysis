import matplotlib.pyplot as plt
import numpy as np
import sys
from definition_plots import ffvs2nd_plot

T_str = sys.argv[1]
outfolder = sys.argv[2]

data_ffvs2nd = f"{outfolder}/data_finitefieldvs2ndorder_{T_str}"

fig, ax = plt.subplots()
ffvs2nd_plot(ax, data_ffvs2nd)
plt.savefig(f"{outfolder}/ffvs2nd_{T_str}.png", dpi=300)
