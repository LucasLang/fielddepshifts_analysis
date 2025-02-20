using MagFieldLFT
using LinearAlgebra

include("modeldefinition.jl")

T = 298.0  # temperature

shparam = get_shparam()
sh = MagFieldLFT.SpinHamiltonian(shparam)       # model used for contact shifts
lft = get_lft()                                 # model used for PCS

# TO DO: calculate tau_tilde_2ndorder only once! (since it is independent from both B0_MHz and grid!)

function calc_error(B0_MHz, grid)
    B0 = B0_MHz/42.577478518/2.35051756758e5  # trafo from MHz to Tesla and then to atomic units

    CS_fieldindep = MagFieldLFT.calc_fieldindep_shifts(sh, T)
    PCS_fieldindep = MagFieldLFT.calc_fieldindep_shifts(lft, T)

    CS_2ndorder = MagFieldLFT.calc_shifts_2ndorder_total(sh, T, B0)
    CS_finitefield = MagFieldLFT.estimate_shifts_finitefield(sh, B0, T, grid)
    PCS_2ndorder = MagFieldLFT.calc_shifts_2ndorder_total(lft, T, B0)
    PCS_finitefield = MagFieldLFT.estimate_shifts_finitefield(lft, B0, T, grid)

    shifts_fieldindep = CS_fieldindep + PCS_fieldindep
    shifts_2ndorder = CS_2ndorder + PCS_2ndorder
    shifts_finitefield = CS_finitefield + PCS_finitefield

    tau_tilde_2ndorder = (shifts_2ndorder - shifts_fieldindep)/(B0_MHz^2)
    tau_tilde_finitefield = (shifts_finitefield - shifts_fieldindep)/(B0_MHz^2)

    error = abs(tau_tilde_finitefield[5] - tau_tilde_2ndorder[5])/abs(tau_tilde_2ndorder[5])  # arbitrarily pick one of the protons

    return error
end

#errormatrix = [calc_error(B0_MHz, lebedev_grids[gridindex]) for B0 in 100:100:2000, gridindex in 5:5:30]
errormatrix = [calc_error(B0_MHz, lebedev_grids[gridindex]) for B0_MHz in 20:1000:10000, gridindex in 1:1:5]
display(errormatrix)
