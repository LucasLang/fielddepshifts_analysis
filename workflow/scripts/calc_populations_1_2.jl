using DelimitedFiles

outfolder = ARGS[1]

const mu_B = 9.2740100657e-24
const g_e = 2.002319
const k_B = 1.380649e-23

const T = 298.0



function get_population_lower(B)
    xi = mu_B * g_e * B / k_B / T
    factor_12 = exp(-xi/2)
    factor_m12 = exp(xi/2)

    Z = factor_12 + factor_m12

    prob_m12 = factor_m12 / Z
    return prob_m12
end

writedlm("$outfolder/populations_spin_1_2", [get_population_lower(28.2), get_population_lower(1000)])

