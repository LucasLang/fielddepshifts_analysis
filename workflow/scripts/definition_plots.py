import numpy as np

def convergence_plot(ax, data_convergence):                                              
    data = np.loadtxt(data_convergence)                                
    mean = data[:,0]
    min = data[:,1]
    max = data[:,2]                                                    
    firstgrid = 1
    lastgrid = data.shape[0]                                           
    x = range(firstgrid, lastgrid+1)                                   
    ax.plot(x, mean, label="mean")
    ax.fill_between(x, max, min, alpha=0.2, label="min to max")        
    ax.set_yscale("log")
    ax.set_xlim(firstgrid, lastgrid)                                   
    ax.set_xlabel("Grid")
    ax.set_ylabel("Deviation relative to largest grid")                
    ax.legend()

def ffvs2nd_plot(ax, data_ffvs2nd):
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

