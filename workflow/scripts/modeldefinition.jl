function get_shparam()
    mult = 3
    from_au = 27.2113834*8065.54477
    # D from casscf-nevpt2 effective hamiltonian
    D = [  3.053926    -5.555174   -16.580693;
    -5.555174    22.210495    -7.191116;
    -16.580693    -7.191116    -0.939858]
    D *= MagFieldLFT.cmm1_Hartree  #from cm-1 to au (Hartree)

    # g from DFT
    g = [2.1384111    0.0084976    0.0250646;
    0.0074791    2.0934328    0.0112682;
    0.0228213    0.0119502    2.1324169]

    # Aiso from DFT
    Aiso_values_MHz = [-0.2331, 0.3653, -0.0954, 0.1193, 5.6580, 0.8620, 2.5742, 1.0047, 2.2524, -0.1988, 0.3778, -0.0329, 0.0972, 5.7645, -0.1113, -0.1049, 1.2796, 4.0481, 3.9413, 0.9147, -0.1715, -0.1959, -3.6282]
    Aiso_values_Hartree = Aiso_values_MHz * 1e6 * 2pi * MagFieldLFT.au_time  # conversion from frequency to energy in atomic units: E = omega = 2pi nu
    Atensors = [Aiso*Matrix(1.0I, 3, 3) for Aiso in Aiso_values_Hartree]
    Nnuc = length(Atensors)
    gamma_1H = 2.6752e8      # proton gyromagnetic ratio in rad/s/T
    gamma_1H *= MagFieldLFT.au_time * MagFieldLFT.au_fluxdensity # proton gyromagnetic ratio in atomic units
    gammas = [gamma_1H for A in 1:Nnuc]

    shparam = MagFieldLFT.SHParam(mult, g, D, Atensors, gammas)
    return shparam
end

function get_lft()
    param = read_AILFT_params_ORCA("NiSAL_HDPT.out", "CASSCF")
    bohrinangstrom = 0.529177210903

    coordinate_matrice = []
    nomi_atomi = []
    coordinate_H = []

    open("nisalhdpt.xyz", "r") do file
        for ln in eachline(file)
            clmn = split(ln)
            push!(nomi_atomi, clmn[1])
            push!(coordinate_matrice, parse.(Float64, clmn[2:end]))
            if clmn[1]=="H"
                push!(coordinate_H, parse.(Float64, clmn[2:end]))
            end
        end
    end

    R = convert(Vector{Vector{Float64}}, coordinate_H) ./ bohrinangstrom

    lft = MagFieldLFT.LFT(param, R)
    return lft
end