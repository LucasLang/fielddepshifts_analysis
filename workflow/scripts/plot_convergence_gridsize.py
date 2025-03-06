import matplotlib.pyplot as plt
import numpy as np
import sys

inputfile = sys.argv[1]

data = np.loadtxt(inputfile)
mean = data[:,0]
min = data[:,1]
max = data[:,2]

firstgrid = 1
lastgrid = data.shape[0]
x = range(firstgrid, lastgrid+1)
plt.plot(x, mean, label="mean")
plt.fill_between(x, max, min, alpha=0.2, label="min to max")
plt.yscale("log")
plt.xlim(firstgrid, lastgrid)
plt.xlabel("Grid")
plt.ylabel("Relative deviation")
plt.legend()
plt.savefig(f"{inputfile}.png", dpi=300)
