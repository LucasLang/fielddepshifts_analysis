using OutputParser
using DelimitedFiles

ORCAfile = ARGS[1]
outfolder = ARGS[2]

D = parse_ZFStensor_Heff(ORCAfile, "NEVPT2")

writedlm("$outfolder/Dtensor", D)