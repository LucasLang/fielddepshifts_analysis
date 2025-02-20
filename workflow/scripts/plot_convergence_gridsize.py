import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("convergence_gridsize_400_298.0")
mean = data[:,0]
min = data[:,1]
max = data[:,2]

firstgrid = 1
lastgrid = 31
x = range(firstgrid, lastgrid+1)
plt.plot(x, mean)
plt.fill_between(x, max, min, alpha=0.2)
plt.yscale("log")
plt.xlim(firstgrid, lastgrid)
plt.xlabel("Grid")
plt.ylabel("Error")
plt.savefig("convergence_gridsize.png", dpi=300)