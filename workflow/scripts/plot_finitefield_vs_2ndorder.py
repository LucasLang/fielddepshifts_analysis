import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("finitefield_vs_2ndorder_298.0")
B0_MHz = data[:,0]
mean = data[:,1]
min = data[:,2]
max = data[:,3]

plt.plot(B0_MHz, mean, label="mean")
plt.fill_between(B0_MHz, max, min, alpha=0.2, label="min to max")
plt.yscale("log")
plt.xscale("log")
plt.xlim(B0_MHz[0], B0_MHz[-1])
plt.xlabel("Proton Larmor frequency / MHz")
plt.ylabel("Relative deviation")
plt.legend()
plt.savefig("finitefield_vs_2ndorder.png", dpi=300)