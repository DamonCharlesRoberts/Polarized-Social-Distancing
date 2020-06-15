##### CONVERT RDS file into CSV file ########
library(foreign)
finaldata <- readRDS('/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data/finaldataset.RDS')
write.csv(finaldata, file = '/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data/finaldataset.csv')
