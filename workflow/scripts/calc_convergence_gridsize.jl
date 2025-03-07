using ParaMag
using LinearAlgebra
using Statistics
using DelimitedFiles

B0_MHz = ARGS[1]
T = ARGS[2]

gridtype = length(ARGS) > 0 ? ARGS[3] : "lebedev"    # possible values: lebedev, repulsion
if gridtype == "lebedev"
    grids = lebedev_grids
    Ngrids = 31     # exclude the last one because it is used as reference
elseif gridtype == "repulsion"
    grids = repulsion_grids
    Ngrids = 11
end

outfolder = ARGS[4]

outputfile = "$(outfolder)/data_convergence_gridsize_$(B0_MHz)_$(T)_$gridtype"

include("modeldefinition.jl")

T = 298.0  # temperature
B0_MHz = 400
B0 = B0_MHz/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units

shparam = get_shparam("$outfolder/model")
sh = ParaMag.SpinHamiltonian(shparam)       # model used for contact shifts
lft = get_lft("$outfolder/model")                                 # model used for PCS



# Always use largest Lebedev grid as reference (its largest grid weight is 1.9075812418031671E-004, whereas the average grid weight of
# the largest repulsion grid is 5E-4)
index_largest = 32
CS_finitefield_largestgrid = ParaMag.estimate_shifts_finitefield(sh, B0, T, lebedev_grids[index_largest])
PCS_finitefield_largestgrid = ParaMag.estimate_shifts_finitefield(lft, B0, T, lebedev_grids[index_largest])
shifts_finitefield_largestgrid = CS_finitefield_largestgrid + PCS_finitefield_largestgrid

results = Array{Float64}(undef, Ngrids, 3)    # for each grid, we save mean, min, and max of the
                                              # absolute deviations with respect to the reference grid.

for gridindex in 1:Ngrids
    grid = lebedev_grids[gridindex]

    CS_finitefield = ParaMag.estimate_shifts_finitefield(sh, B0, T, grid)
    PCS_finitefield = ParaMag.estimate_shifts_finitefield(lft, B0, T, grid)
    shifts_finitefield = CS_finitefield + PCS_finitefield
    absolutedeviations = abs.(shifts_finitefield - shifts_finitefield_largestgrid)
    relativedeviations = absolutedeviations ./ abs.(shifts_finitefield_largestgrid)
    results[gridindex, 1] = mean(relativedeviations)
    results[gridindex, 2] = minimum(relativedeviations)
    results[gridindex, 3] = maximum(relativedeviations)
end

writedlm(outputfile, results)
