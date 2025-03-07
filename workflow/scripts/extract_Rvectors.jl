using OutputParser
using DelimitedFiles

ORCAfile = ARGS[1]
outfolder = ARGS[2]
refatom = "Ni"

elements, coord = parse_ORCA_structure(ORCAfile)

H_indices = findall(==("H"), elements)
ref_index = findall(==(refatom), elements)
if length(ref_index) != 1
    error("Ambiguity because more than one reference atom was found!")
end
ref_index = ref_index[1]

Rvectors = [coord[ref_index] - coord[i] for i in H_indices]

Rvectors_matrix = vcat(Rvectors'...)    # turn vector of vectors into 2D matrix

writedlm("$outfolder/Rvectors", Rvectors_matrix)