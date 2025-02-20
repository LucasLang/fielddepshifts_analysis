using MagFieldLFT
using LinearAlgebra
using Statistics
using DelimitedFiles

include("modeldefinition.jl")

T = 298.0  # temperature
B0_MHz = 400
B0 = B0_MHz/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units

shparam = get_shparam()
sh = MagFieldLFT.SpinHamiltonian(shparam)       # model used for contact shifts
lft = get_lft()                                 # model used for PCS

Ngrids = 32

CS_finitefield_largestgrid = MagFieldLFT.estimate_shifts_finitefield(sh, B0, T, lebedev_grids[Ngrids])
PCS_finitefield_largestgrid = MagFieldLFT.estimate_shifts_finitefield(lft, B0, T, lebedev_grids[Ngrids])
shifts_finitefield_largestgrid = CS_finitefield_largestgrid + PCS_finitefield_largestgrid

results = Array{Float64}(undef, Ngrids-1, 3)    # for each grid, we save mean, min, and max of the
                                                # absolute deviations with respect to the largest grid.

for gridindex in 1:(Ngrids-1)
    grid = lebedev_grids[gridindex]

    CS_finitefield = MagFieldLFT.estimate_shifts_finitefield(sh, B0, T, grid)
    PCS_finitefield = MagFieldLFT.estimate_shifts_finitefield(lft, B0, T, grid)
    shifts_finitefield = CS_finitefield + PCS_finitefield
    absolutedeviations = abs.(shifts_finitefield - shifts_finitefield_largestgrid)
    relativedeviations = absolutedeviations ./ abs.(shifts_finitefield_largestgrid)
    results[gridindex, 1] = mean(relativedeviations)
    results[gridindex, 2] = minimum(relativedeviations)
    results[gridindex, 3] = maximum(relativedeviations)
end

writedlm("convergence_gridsize_$(B0_MHz)_$T", results)