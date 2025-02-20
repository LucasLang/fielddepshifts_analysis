using MagFieldLFT
using LinearAlgebra
using Statistics
using DelimitedFiles

include("modeldefinition.jl")

T = 298.0  # temperature
#grid = lebedev_grids[3]
grid = lebedev_grids[10]

shparam = get_shparam()
sh = MagFieldLFT.SpinHamiltonian(shparam)       # model used for contact shifts
lft = get_lft()                                 # model used for PCS

B0_MHz_values = [val for val in 100:10:3000]
results = Array{Float64}(undef, length(B0_MHz_values), 4)    # we store B0_MHz, mean, min, max

for (i, B0_MHz) in enumerate(B0_MHz_values)
    B0 = B0_MHz/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units
    CS_2ndorder = MagFieldLFT.calc_shifts_2ndorder_total(sh, T, B0)
    CS_finitefield = MagFieldLFT.estimate_shifts_finitefield(sh, B0, T, grid)
    PCS_2ndorder = MagFieldLFT.calc_shifts_2ndorder_total(lft, T, B0)
    PCS_finitefield = MagFieldLFT.estimate_shifts_finitefield(lft, B0, T, grid)

    shifts_2ndorder = CS_2ndorder + PCS_2ndorder
    shifts_finitefield = CS_finitefield + PCS_finitefield
    relative_deviation = abs.(shifts_2ndorder - shifts_finitefield) ./ abs.(shifts_finitefield)
    results[i, 1] = B0_MHz
    results[i, 2] = mean(relative_deviation)
    results[i, 3] = minimum(relative_deviation)
    results[i, 4] = maximum(relative_deviation)
end

writedlm("finitefield_vs_2ndorder_$T", results)