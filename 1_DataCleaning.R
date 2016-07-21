# Inducing Cognitive Processes
# Michael Schulte-Mecklenbeck
# Scripts for: Schulte-Mecklenbeck, M., Kuhberger, A., Gagl, S., & Hutzler, F. (submitted). 
# Inducing Cognitive Processes: Bringing Process Measures and Cognitive Processes Closer Together

# clean slate
rm(list=ls(all=TRUE))
# set working directory 
setwd("~/Dropbox (2.0)/4_ProcessTracingProjects/SalzburgEyetracking/GitHubRepo/InducingCognitiveProcesses") # MODIFY!!
# load raw data
raw <- readRDS(file = 'data/raw.RDS')

# packages we need
require(car)

# clean rawdata files ---------------------------------------------------------

# remove g from gamble vector
raw$gamble <- gsub("[g]", "", as.character(raw$gamble))
# remove pos from position vector
raw$position <- gsub("[pos]", "", as.character(raw$position))

# "G" represents win (outcome) and "C" Chance (probability).
# add option variable from AOI name
raw$type <- substr(raw$AOI, 1, 1)
raw$type <- ifelse(raw$type=='g', "O", "P")
# rename position in orientation 
# recode from h,q to h,v
raw$orient <- ifelse(as.character(raw$orientation)=='h', "h", "v")
raw$orientation <- NULL

# add setup of gambles
stimcode_extract <- strsplit(as.character(raw$stimcode), '_')
raw$s1 <- sapply(stimcode_extract, "[", 1)
raw$s2 <- sapply(stimcode_extract, "[", 3)
raw$s3 <- sapply(stimcode_extract, "[", 5)
raw$s4 <- sapply(stimcode_extract, "[", 7)
raw$s5 <- sapply(stimcode_extract, "[", 9)
raw$s6 <- sapply(stimcode_extract, "[", 11)
raw$s7 <- sapply(stimcode_extract, "[", 13)
raw$s8 <- sapply(stimcode_extract, "[", 15)

raw$v1 <- sapply(stimcode_extract, "[", 2)
raw$v2 <- sapply(stimcode_extract, "[", 4)
raw$v3 <- sapply(stimcode_extract, "[", 6)
raw$v4 <- sapply(stimcode_extract, "[", 8)
raw$v5 <- sapply(stimcode_extract, "[", 10)
raw$v6 <- sapply(stimcode_extract, "[", 12)
raw$v7 <- sapply(stimcode_extract, "[", 14)
raw$v8 <- sapply(stimcode_extract, "[", 16)

# subset for stimcode checking
stimulus_counter <- raw[raw$nfixGesamt == 1,]
stimulus_counter <- subset(stimulus_counter, select=c(vp, gamble, s1,s2,s3,s4,s5,s6,s7,s8,v1,v2,v3,v4,v5,v6,v7,v8))

# recode gamble numbers into task numbers
# in order to correspond to material/Gambles_Gewinnausschüttung.xls
raw$task <- 0
raw$task <- ifelse(raw$gamble == 1, 7,
            ifelse(raw$gamble == 2, 10,
            ifelse(raw$gamble == 3, 11,
            ifelse(raw$gamble == 4, 14,
            ifelse(raw$gamble == 5, 18,
            ifelse(raw$gamble == 6, 19,
            ifelse(raw$gamble == 7, 5,
            ifelse(raw$gamble == 8, 9,
            ifelse(raw$gamble == 9, 13,
            ifelse(raw$gamble == 10, 16,
            ifelse(raw$gamble == 11, 17,
            ifelse(raw$gamble == 12, 24,
            ifelse(raw$gamble == 13, 1,
            ifelse(raw$gamble == 14, 6,
            ifelse(raw$gamble == 15, 12,
            ifelse(raw$gamble == 16, 15,
            ifelse(raw$gamble == 17, 20,
            ifelse(raw$gamble == 18, 23,
            ifelse(raw$gamble == 19, 2,
            ifelse(raw$gamble == 20, 3,
            ifelse(raw$gamble == 21, 4,
            ifelse(raw$gamble == 22, 8,
            ifelse(raw$gamble == 23, 21,
            ifelse(raw$gamble == 24, 22,'0'
            ))))))))))))))))))))))))

# add variable with gain and loss gambles
raw$gambletype <- ifelse(raw$task %in% c(6,11,17,5,7,12,9,8,10,18,23,24), raw$gambletype <- 'loss', raw$gambletype <- 'gain')

# add variable with reasons of PH 
raw$reasons <- ifelse(raw$task %in% c(1,2,3,4,5,6,7,8,9,10,11,12),raw$reasons <- 'one reason',
                      ifelse(raw$task %in% c(13,14,15,16,17,18),raw$reasons <- 'two reasons',
                      raw$reasons <- 'three reasons'))

raw$reasons <- factor(raw$reasons, c("one reason","two reasons", "three reasons"))

# condition completion - sequence ----------------------------------------------------
# vp = 25 was replaced with vp 23 in the second trial - lets fix that
raw[(raw$vp == 25 & raw$orientation == 'h'),]$vp <- 23

# add sequence to actual data
raw$seq <- seq(1,dim(raw)[1])

lines <- data.frame(min = 0,max = 0,vp = 0)
for(i in 1:length(unique(raw$vp))){
  lines[i,]$min <- min(raw[raw$vp == i,]$seq) 
  lines[i,]$max <- max(raw[raw$vp == i,]$seq)
  lines[i,]$vp <- i
}
lines

conditions <- data.frame(first = 0,second = 0,vp = 0)
for(i in 1:dim(lines)[1]){
  conditions[i,]$first <-  as.character(raw[lines[i,1],]$condition)
  conditions[i,]$second <-  as.character(raw[lines[i,2],]$condition)
  conditions[i,]$vp <- i
}

conditions_for_merge <- data.frame(order = paste(conditions$first, conditions$second), vp = conditions$vp)

# merge into raw dataframe
raw <- merge(raw, conditions_for_merge, by.x = 'vp', by.y = 'vp')


# recode AOIs into maxmin in variable PH

    raw$PH = NA
    raw$RealValue<- as.character(raw$RealValue)
    
    raw[raw$gamble ==   '1',]$PH <- Recode(raw[raw$gamble ==   '1',]$RealValue, "'-500'='min';'0.2'='min';'-800'='2nd';'0.8'='2nd';'-600'='3rd';'0.4'='3rd';'-820'='max';'0.6'='max'")
    raw[raw$gamble ==   '2',]$PH <- Recode(raw[raw$gamble ==   '2',]$RealValue, "'-400'='min'; '0.15'='min'; '-880'='2nd';  '0.85'='2nd'; '-500'='3rd';  '0.1'='3rd'; '-50'='3rd';  '0.1'='3rd';  '-900'='max';  '0.9'='max'")
    raw[raw$gamble ==   '3',]$PH <- Recode(raw[raw$gamble ==   '3',]$RealValue, "'-1700'='min'; '0.55'='3rd';'-200'='min'; '0.6'='3rd'; '-2350'='2nd';  '0.4'='2nd'; '-2000'='3rd'; '0.6'='3rd'; '-2500'='max';  '0.45'='max'")
    raw[raw$gamble ==   '4',]$PH <- Recode(raw[raw$gamble ==   '4',]$RealValue, "'1000'='min'; '0.7'='min'; '1000'='min';  '0.3'='min';   '1300'='2nd';  '0.5'='2nd';  '1600'='max';  '0.5'='max'")
    raw[raw$gamble ==   '5',]$PH <- Recode(raw[raw$gamble ==   '5',]$RealValue, "'0'='min'; '0.55'='min'; '0'='min';  '0.1'='min';   '-3000'='2nd';  '0.9'='2nd'; '-6000'='max';	'0.45'='max'")
    raw[raw$gamble ==   '6',]$PH <- Recode(raw[raw$gamble ==   '6',]$RealValue, "'2000'='min'; '0.75'='min'; '6000'='2nd';  '0.3'='2nd';   '2500'='3rd';  '0.7'='3rd';  '8200'='max';  '0.25'='max'")
    raw[raw$gamble ==   '7',]$PH <- Recode(raw[raw$gamble ==   '7',]$RealValue, "'-500'='min'; '-400'='min'; '0.4'='min'; '-1000'='2nd';  '0.6'='2nd';   '-2000'='max';  '0.4'='max';  '-2000'='max';  '0.6'='max'")
    raw[raw$gamble ==   '8',]$PH <- Recode(raw[raw$gamble ==   '8',]$RealValue, "'-100'='min'; '0.3'='min'; '-1000'='2nd';  '0.35'='2nd';   '-5000'='max';  '0.65'='max';  '-5000'='max';  '0.7'='max'")
    raw[raw$gamble ==   '9',]$PH <- Recode(raw[raw$gamble ==   '9',]$RealValue, "'0'='min'; '0.5'='min'; '2000'='2nd';  '0.5'='2nd';   '300'='3rd';  '0.8'='3rd';  '4000'='max';  '0.2'='max'")
    raw[raw$gamble ==  '10',]$PH <- Recode(raw[raw$gamble ==  '10',]$RealValue, "'0'='min'; '0.55'='min'; '0'='min';  '0.1'='min';   '3000'='2nd';  '0.9'='2nd';  '6000'='max';  '0.45'='max'")
    raw[raw$gamble ==  '11',]$PH <- Recode(raw[raw$gamble ==  '11',]$RealValue, "'-1000'='min'; '0.7'='min'; '-1000'='min';  '0.5'='min';   '-1300'='2nd';  '0.5'='2nd';  '-1600'='max';  '0.3'='max'")
    raw[raw$gamble ==  '12',]$PH <- Recode(raw[raw$gamble ==  '12',]$RealValue, "'0'='min'; '0.999'='min'; '0'='min';  '0.998'='min';   '-3000'='2nd';  '0.002'='2nd';  '-6000'='max';  '0.001'='max'")
    raw[raw$gamble ==  '13',]$PH <- Recode(raw[raw$gamble ==  '13',]$RealValue, "'500'='min'; '0.4'='min'; '1000'='2nd';  '0.6'='2nd';   '2000'='max';  '0.6'='max';  '2000'='max';  '0.4'='max'")
    raw[raw$gamble ==  '14',]$PH <- Recode(raw[raw$gamble ==  '14',]$RealValue, "'-2000'='min'; '0.7'='min'; '-4800'='2nd';  '0.1'='2nd';   '-2800'='3rd';  '0.9'='3rd';  '-5000'='max';  '0.3'='max'")
    raw[raw$gamble ==  '15',]$PH <- Recode(raw[raw$gamble ==  '15',]$RealValue, "'-150'='min'; '0.7'='min'; '0.85'='min'; '-2400'='2nd';  '0.1'='2nd';   '-650'='3rd';  '0.9'='3rd';  '-2500'='max';  '0.3'='max'")
    raw[raw$gamble ==  '16',]$PH <- Recode(raw[raw$gamble ==  '16',]$RealValue, "'200'='min'; '0.8'='min'; '200'='min'; '-400'='min'; '0.6'='min';   '1000'='2nd';  '0.4'='2nd';  '1800'='max';  '0.2'='max'")
    raw[raw$gamble ==  '17',]$PH <- Recode(raw[raw$gamble ==  '17',]$RealValue, "'1750'='min'; '0.65'='min'; '3000'='2nd';  '0.4'='2nd';   '2000'='3rd';  '0.15'='3rd'; '0.6'='3rd';  '3600'='max';  '0.35'='max'")
    raw[raw$gamble ==  '18',]$PH <- Recode(raw[raw$gamble ==  '18',]$RealValue, "'0'='min'; '0.8'='min'; '0'='min';  '0.75'='min';   '-3000'='2nd';  '0.25'='2nd';  '-880'='2nd';  '0.25'='2nd';'-4000'='max';  '0.2'='max'")
    raw[raw$gamble ==  '19',]$PH <- Recode(raw[raw$gamble ==  '19',]$RealValue, "'1000'='min'; '0.3'='min'; '3000'='2nd';  '0.7'='2nd';   '2000'='3rd';  '0.8'='3rd';  '4000'='max';  '0.2'='max'")
    raw[raw$gamble ==  '20',]$PH <- Recode(raw[raw$gamble ==  '20',]$RealValue, "'500'='min'; '0.2'='min'; '800'='2nd';  '0.8'='2nd';   '600'='3rd';  '0.4'='3rd';  '820'='max';  '0.6'='max'")
    raw[raw$gamble ==  '21',]$PH <- Recode(raw[raw$gamble ==  '21',]$RealValue, "'100'='min'; '0.3'='min'; '1000'='2nd';  '0.35'='2nd';   '5000'='max';  '0.65'='max';  '5000'='max';  '0.7'='max'")
    raw[raw$gamble ==  '22',]$PH <- Recode(raw[raw$gamble ==  '22',]$RealValue, "'-50'='min'; '0.3'='min'; '-3400'='2nd';  '0.65'='2nd';   '-600'='3rd';  '0.35'='3rd';  '-3500'='max';  '0.7'='max'")
    raw[raw$gamble ==  '23',]$PH <- Recode(raw[raw$gamble ==  '23',]$RealValue, "'0'='min'; '0.999'='min'; '0'='min';  '0.998'='min';   '3000'='2nd';  '0.002'='2nd';  '6000'='max';  '0.001'='max'")
    raw[raw$gamble ==  '24',]$PH <- Recode(raw[raw$gamble ==  '24',]$RealValue, "'0'='min'; '0.8'='min'; '3000'='2nd';  '0.25'='2nd';   '0'='min';  '0.75'='min';  '4000'='max';  '0.2'='max'")

# recode PHrelations into PH
# raw$AOI <- as.character(raw$AOI)
# raw$PH <- NA
# raw[raw$gamble ==  '1',]$PH <- recode(raw[raw$gamble ==  '1',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='2nd';  'c2s1'='2nd';   'g1s2'='3rd';  'c1s2'='3rd';  'g2s2'='max'; 'c2s2'='max'")
# raw[raw$gamble ==  '2',]$PH <- recode(raw[raw$gamble ==  '2',]$AOI, "'g1s1'='3rd'; 'c1s1'='3rd'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='min';  'c1s2'='min';	'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble ==  '3',]$PH <- recode(raw[raw$gamble ==  '3',]$AOI, "'g1s1'='3rd'; 'c1s1'='3rd'; 'g2s1'='2nd';  'c2s1'='2nd';   'g1s2'='min';  'c1s2'='min';  'g2s2'='max';	'c2s2'='max'")
# raw[raw$gamble ==  '4',]$PH <- recode(raw[raw$gamble ==  '4',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='2nd';  'c2s1'='2nd';   'g1s2'='min';  'c1s2'='min';  'g2s2'='max';	'c2s2'='max'")
# raw[raw$gamble ==  '5',]$PH <- recode(raw[raw$gamble ==  '5',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='min';  'c1s2'='min';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble ==  '6',]$PH <- recode(raw[raw$gamble ==  '6',]$AOI, "'g1s1'='2nd'; 'c1s1'='2nd'; 'g2s1'='3rd';  'c2s1'='3rd';   'g1s2'='max';  'c1s2'='max';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble ==  '7',]$PH <- recode(raw[raw$gamble ==  '7',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='2nd';  'c1s2'='2nd';  'g2s2'='max';	'c2s2'='max'")
# raw[raw$gamble ==  '8',]$PH <- recode(raw[raw$gamble ==  '8',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='2nd';  'c2s1'='2nd';   'g1s2'='max';  'c1s2'='max';  'g2s2'='max';	'c2s2'='max'")
# raw[raw$gamble ==  '9',]$PH <- recode(raw[raw$gamble ==  '9',]$AOI, "'g1s1'='3rd'; 'c1s1'='3rd'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='max';  'c1s2'='max';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '10',]$PH <- recode(raw[raw$gamble == '10',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='2nd';  'c1s2'='2nd';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '11',]$PH <- recode(raw[raw$gamble == '11',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='2nd';  'c1s2'='2nd';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '12',]$PH <- recode(raw[raw$gamble == '12',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='min';  'c1s2'='min';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '13',]$PH <- recode(raw[raw$gamble == '13',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='3rd';  'c2s1'='3rd';   'g1s2'='max';  'c1s2'='max';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '14',]$PH <- recode(raw[raw$gamble == '14',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='3rd';  'c1s2'='3rd';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '15',]$PH <- recode(raw[raw$gamble == '15',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='3rd';  'c1s2'='3rd';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '16',]$PH <- recode(raw[raw$gamble == '16',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='2nd';  'c1s2'='2nd';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '17',]$PH <- recode(raw[raw$gamble == '17',]$AOI, "'g1s1'='2nd'; 'c1s1'='2nd'; 'g2s1'='3rd';  'c2s1'='3rd';   'g1s2'='max';  'c1s2'='max';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '18',]$PH <- recode(raw[raw$gamble == '18',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='min';  'c1s2'='min';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '19',]$PH <- recode(raw[raw$gamble == '19',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='2nd';  'c2s1'='2nd';   'g1s2'='3rd';  'c1s2'='3rd';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '20',]$PH <- recode(raw[raw$gamble == '20',]$AOI, "'g1s1'='2nd'; 'c1s1'='2nd'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='max';  'c1s2'='max';  'g2s2'='3rd';	'c2s2'='3rd'")
# raw[raw$gamble == '21',]$PH <- recode(raw[raw$gamble == '21',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='max';  'c1s2'='max';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '22',]$PH <- recode(raw[raw$gamble == '22',]$AOI, "'g1s1'='min'; 'c1s1'='min'; 'g2s1'='max';  'c2s1'='max';   'g1s2'='3rd';  'c1s2'='3rd';  'g2s2'='2nd';	'c2s2'='2nd'")
# raw[raw$gamble == '23',]$PH <- recode(raw[raw$gamble == '23',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='2nd';  'c1s2'='2nd';  'g2s2'='min';	'c2s2'='min'")
# raw[raw$gamble == '24',]$PH <- recode(raw[raw$gamble == '24',]$AOI, "'g1s1'='max'; 'c1s1'='max'; 'g2s1'='min';  'c2s1'='min';   'g1s2'='min';  'c1s2'='min';  'g2s2'='2nd';	'c2s2'='2nd'")

# housekeeping
remove(conditions, conditions_for_merge, lines, i, stimulus_counter, stimcode_extract)

# save raw clean data file 
saveRDS(raw, file = "data/raw_clean.RDS")
