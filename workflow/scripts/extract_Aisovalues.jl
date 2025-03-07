using OutputParser
using DelimitedFiles

ORCAfile = ARGS[1]
outfolder = ARGS[2]

elements, coord = parse_ORCA_structure(ORCAfile)

H_indices = findall(==("H"), elements)
nuclei = ["$(index-1)H" for index in H_indices]     # have to subtract 1 because ORCA starts counting at 0
Aiso_values = parse_Aiso_EPRNMR(ORCAfile, nuclei)

writedlm("$outfolder/Aiso_values", Aiso_values)