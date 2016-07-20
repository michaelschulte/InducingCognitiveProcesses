# Inducing Cognitive Processes
# Michael Schulte-Mecklenbeck
# Scripts for: Schulte-Mecklenbeck, M., Kuhberger, A., Gagl, S., & Hutzler, F. (submitted). 
# Inducing Cognitive Processes: Bringing Process Measures and Cognitive Processes Closer Together

# Variables
# vp [1:48], list {1:8}, orientation [h, q],  gamble [1:24], stimcode, condition [FREE, PH, EV],	
# AOI fixtime	nfixAOI	nfixGesamt position PHrelations RealValue choice

# clean slate
rm(list=ls(all=TRUE))
# set working directory 
setwd("~/Dropbox (2.0)/4_ProcessTracingProjects/SalzburgEyetracking/GitHubRepo/InducingCognitiveProcesses") # MODIFY!!

# read raw data from dropbox    
raw <- read.table("data/rawdata.csv", header=TRUE, sep=',')

# save raw datafile
saveRDS(raw, file = 'data/raw.RDS')
