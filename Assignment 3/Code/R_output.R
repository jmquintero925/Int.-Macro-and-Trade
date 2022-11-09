#********************************************************************************
#********************************************************************************
#********** Int. Macro and Trade. 		****************************************
#********** Assignment 3: Table 1 		****************************************
#********** Jose M. Quintero 				**********************************************
#*********************************************************************************
#*********************************************************************************
#*

# Load libraries
library(foreign)
library(fixest)
library(readr)
library(tictoc)

# Change working directory 
setwd("/Users/josemiguelquinteroholguin/Library/CloudStorage/Dropbox/UChicago/2nd Year Classes/Int.-Macro-and-Trade/Assignment 3")

# Read data
Detroit <- read_csv("Data/Detroit.csv", col_names = TRUE, De)

tic("carajo")
# Run regression
reg1 = feols(fml = log(flows) ~ log(distance_Google_miles) | work_ID + home_ID, data = Detroit, vcov = "hetero")
toc()

summary(reg1)