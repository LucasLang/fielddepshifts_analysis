using ParaMag
using LinearAlgebra
using DelimitedFiles

include("modeldefinition.jl")

AILFTfile = ARGS[1]
outfolder = ARGS[2]

# SETTINGS
T = 298.0
B0_MHz_highfield = 1200.0
B0_highfield = B0_MHz_highfield/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units
B0_MHz_lowfield = 400.0
B0_lowfield = B0_MHz_lowfield/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units

# CONTACT SHIFTS

shparam = get_shparam("$outfolder/model")
sh = ParaMag.SpinHamiltonian(shparam)
contactshifts_lowfield = ParaMag.calc_shifts_2ndorder_total(sh, T, B0_lowfield)
contactshifts_highfield = ParaMag.calc_shifts_2ndorder_total(sh, T, B0_highfield)

# PSEUDOCONTACT SHIFTS

lft = get_lft(AILFTfile, "$outfolder/model")
PCS_lowfield = ParaMag.calc_shifts_2ndorder_total(lft, T, B0_lowfield)
PCS_highfield = ParaMag.calc_shifts_2ndorder_total(lft, T, B0_highfield)

# TOTAL SHIFTS

shifts_lowfield = contactshifts_lowfield + PCS_lowfield
shifts_highfield = contactshifts_highfield + PCS_highfield
shifts_diff = shifts_highfield - shifts_lowfield

writedlm("$outfolder/data_shifts_2ndorder", [shifts_lowfield shifts_highfield])

