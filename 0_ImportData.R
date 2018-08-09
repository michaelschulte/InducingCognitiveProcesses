# Inducing Cognitive Processes
# Michael Schulte-Mecklenbeck
# Scripts for: Schulte-Mecklenbeck, M., Kühberger, A., Gagl, S., & Hutzler, F. (2017). Inducing thought processes: Bringing process measures and cognitive processes closer together. Journal of Behavioral Decision Making, 30(5), 1001-1013.

# Variables
# vp [1:48], list {1:8}, orientation [h, q],  gamble [1:24], stimcode, condition [FREE, PH, EV],	
# AOI fixtime	nfixAOI	nfixGesamt position PHrelations RealValue choice

# read raw data from    
raw <- read.table("data/0_rawdata.csv", header=TRUE, sep=',')

# save raw datafile
saveRDS(raw, file = 'data/1_raw.RDS')