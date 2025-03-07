using ParaMag
using LinearAlgebra
using Statistics
using DelimitedFiles

include("modeldefinition.jl")

T_str = ARGS[1]    # temperature
T = parse(Float64, T_str)
outfolder = ARGS[2]

grid = lebedev_grids[3]

shparam = get_shparam("$outfolder/model")
sh = ParaMag.SpinHamiltonian(shparam)       # model used for contact shifts
lft = get_lft("$outfolder/model")         # model used for PCS

B0_MHz_values = [val for val in 100:10:3000]
results = Array{Float64}(undef, length(B0_MHz_values), 4)    # we store B0_MHz, mean, min, max

for (i, B0_MHz) in enumerate(B0_MHz_values)
    B0 = B0_MHz/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units
    CS_2ndorder = ParaMag.calc_shifts_2ndorder_total(sh, T, B0)
    CS_finitefield = ParaMag.estimate_shifts_finitefield(sh, B0, T, grid)
    PCS_2ndorder = ParaMag.calc_shifts_2ndorder_total(lft, T, B0)
    PCS_finitefield = ParaMag.estimate_shifts_finitefield(lft, B0, T, grid)

    shifts_2ndorder = CS_2ndorder + PCS_2ndorder
    shifts_finitefield = CS_finitefield + PCS_finitefield
    relative_deviation = abs.(shifts_2ndorder - shifts_finitefield) ./ abs.(shifts_finitefield)
    results[i, 1] = B0_MHz
    results[i, 2] = mean(relative_deviation)
    results[i, 3] = minimum(relative_deviation)
    results[i, 4] = maximum(relative_deviation)
end

writedlm("$outfolder/data_finitefieldvs2ndorder_$T_str", results)
