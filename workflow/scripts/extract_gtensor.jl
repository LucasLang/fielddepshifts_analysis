using OutputParser
using DelimitedFiles

ORCAfile = ARGS[1]
outfolder = ARGS[2]

g = parse_gtensor_EPRNMR(ORCAfile)

writedlm("$outfolder/gtensor", g)