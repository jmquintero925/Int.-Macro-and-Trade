#################################################
# Filename: fe.jl
# Author: Craig A. Chikis
# Date: 11/03/2022
# Note(s):
#################################################


using FixedEffectModels, RegressionTables, DataFrames, DataFramesMeta
import CSV

# Load data
data0 = DataFrame(CSV.File("Data/Detroit.csv"));