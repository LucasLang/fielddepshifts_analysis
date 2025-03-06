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

