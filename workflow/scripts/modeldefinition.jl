using DelimitedFiles

function get_shparam(modelfolder)
    mult = 3
    from_au = 27.2113834*8065.54477
    # D from casscf-nevpt2 effective hamiltonian
    D = readdlm("$modelfolder/Dtensor")
    D *= ParaMag.cmm1_Hartree  #from cm-1 to au (Hartree)

    # g from DFT
    g = [2.1384111    0.0084976    0.0250646;
    0.0074791    2.0934328    0.0112682;
    0.0228213    0.0119502    2.1324169]

    # Aiso from DFT
    Aiso_values_MHz = [-0.2331, 0.3653, -0.0954, 0.1193, 5.6580, 0.8620, 2.5742, 1.0047, 2.2524, -0.1988, 0.3778, -0.0329, 0.0972, 5.7645, -0.1113, -0.1049, 1.2796, 4.0481, 3.9413, 0.9147, -0.1715, -0.1959, -3.6282]
    Aiso_values_Hartree = Aiso_values_MHz * 1e6 * 2pi * ParaMag.au_time  # conversion from frequency to energy in atomic units: E = omega = 2pi nu
    Atensors = [Aiso*Matrix(1.0I, 3, 3) for Aiso in Aiso_values_Hartree]
    Nnuc = length(Atensors)
    gamma_1H = 2.6752e8      # proton gyromagnetic ratio in rad/s/T
    gamma_1H *= ParaMag.au_time * ParaMag.au_fluxdensity # proton gyromagnetic ratio in atomic units
    gammas = [gamma_1H for A in 1:Nnuc]

    shparam = ParaMag.SHParam(mult, g, D, Atensors, gammas)
    return shparam
end

function get_lft(AILFTfile, modelfolder)
    param = read_AILFT_params_ORCA(AILFTfile, "NEVPT2")
    bohrinangstrom = 0.529177210903

    Rvectors = readdlm("$modelfolder/Rvectors")
    R_H_NiSAL_angstrom = collect(eachrow(Rvectors))

    R_H_NiSAL_bohr = R_H_NiSAL_angstrom ./ bohrinangstrom

    lft = ParaMag.LFT(param, R_H_NiSAL_bohr)
    return lft
end
