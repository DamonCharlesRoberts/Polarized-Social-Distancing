##############################
# COVID Safe Graph Data Load #
##############################

#  The two options here are to either use python code,
# to download the files manually and to have them sync with our dropbox about once a week or so or to use R. 
# I thought this approach might be the most tolerable. I definitely would prefer to not download 15+ GB of Data. 
# I'll comment the code out as well as possible and have it show all outputs I get into R to make it easy for 
# reproduction in the future (and for you to check to make sure I do not mess anything up too terribly). 


######################################
# Set up AWS Connection to Safe Graph#
######################################

#install.packages('aws.s3') uncomment this if installation is needed
library(aws.s3) #tell R to use the aws.s3 package to let me connect with the data
# Code below
# tells r to set an environment, like a file to just load to remember our credentials and what data we want to pull from
# the data we are loading is a monthly download of foot traffic and demographic aggregations of where people go, where they came from, etc. 
# This should be most useful for my suspicion. I think weekly data is overkill. 
# Sys.setenv(
#'AWS_ACCESS_KEY_ID' = 'AKIAWWZ7POZOGSC3KT64',
#'AWS_SECRET_ACCESS_KEY' = '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',
#"AWS_DEFAULT_REGION" = "us-west-2"
#)

#May 2020 and Beyond: 
#s3://sg-c19-response/monthly-patterns/patterns/

# The data we are loading is a monthly download of foot traffic and demographic aggregations of where people go, where they came from, etc. This should be most useful for my suspicion. I think weekly data is overkill. 
#{r AWS data load, eval = FALSE}
# data <- s3read_using(read.csv,
#       object = "s3://sg-c19-response/monthly-patterns/patterns_backfill/2020/05/07/12.csv.gz")





#############################
# Load Social Distance Data #
#############################

# Load .csv.gz files using fread
# If using smart sync in dropbox, be sure to switch all the files to local first
library(R.utils)
library(readr)
library(data.table)
library(dplyr)
setwd('~/Dropbox/Spatial COVID 19/AWS Data/socialdistance/2020') #set the working directory
set.seed(1357) #we can call this seed for replication purposes. 
#It will use the same bootstrapping algorithm so that we can get really similar samples in the future if needed

## January, 2020

socialdistance1.1.20 <- fread('01/01/2020-01-01-social-distancing.csv.gz') %>%
  mutate(day=1)# use the fread function in data.table and R.utils packages to read compressed csv files.
#mutate(day = #) creates a day variable and sets the value to 1 so that we can keep track of temporal changes among observations.
socialdistance1.1.sample <- sample_frac(socialdistance1.1.20, .05, replace = TRUE)# Bootstrapping 5% of observations by day. SRS with replacement. 
# It looks like it doesn't require much data cleaning. Yay! Just merging data sets and such.
socialdistance1.2.20 <- fread('01/02/2020-01-02-social-distancing.csv.gz') %>%
  mutate(day=2)
socialdistance1.2.sample <- sample_frac(socialdistance1.1.20, .05, replace = TRUE)
socialdistance1.3.20 <- fread('01/03/2020-01-03-social-distancing.csv.gz') %>%
  mutate(day=3)
socialdistance1.3.sample <- sample_frac(socialdistance1.3.20, .05, replace = TRUE)
socialdistance1.4.20 <- fread('01/04/2020-01-04-social-distancing.csv.gz') %>%
  mutate(day = 4)
socialdistance1.4.sample <- sample_frac(socialdistance1.4.20, .05,replace = TRUE)
socialdistance1.5.20 <- fread('01/05/2020-01-05-social-distancing.csv.gz') %>%
  mutate(day=5)
socialdistance1.5.sample <- sample_frac(socialdistance1.5.20, .05, replace = TRUE)
socialdistance1.6.20 <- fread('01/06/2020-01-06-social-distancing.csv.gz') %>%
  mutate(day=6)
socialdistance1.6.sample <- sample_frac(socialdistance1.6.20, .05, replace = TRUE)
socialdistance1.7.20 <- fread('01/07/2020-01-07-social-distancing.csv.gz') %>%
  mutate(day=7)
socialdistance1.7.sample <- sample_frac(socialdistance1.7.20, .05, replace = TRUE)

socialdistance1.1.sampledf <- as.data.frame(socialdistance1.1.sample) #Takes all the bootsrapped samples and turns it into a dataframe for that week.
socialdistance1.2.sampledf <- as.data.frame(socialdistance1.2.sample)
socialdistance1.3.sampledf <- as.data.frame(socialdistance1.3.sample)
socialdistance1.4.sampledf <- as.data.frame(socialdistance1.4.sample)
socialdistance1.5.sampledf <- as.data.frame(socialdistance1.5.sample)
socialdistance1.6.sampledf <- as.data.frame(socialdistance1.6.sample)
socialdistance1.7.sampledf <- as.data.frame(socialdistance1.7.sample)
socialdistancewk1 <- bind_rows(
  socialdistance1.1.sampledf,
  socialdistance1.2.sampledf,
  socialdistance1.3.sampledf,
  socialdistance1.4.sampledf,
  socialdistance1.5.sampledf,
  socialdistance1.6.sampledf,
  socialdistance1.7.sampledf
) # Takes those daily bootstrapped sample dataframes and makes one weeks worth of data coming from the sample
saveRDS(socialdistancewk1, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk1.RDS') # save this into a file that you can simply reload in later. 
# Don't want to over load the RAM by keeping all this data in my R session. Clear everything out after sampling for one week

# Now do it all again for the next week...

socialdistance1.8.20 <- fread('01/08/2020-01-08-social-distancing.csv.gz') %>%
  mutate(day = 8)
socialdistance1.8.sample <- sample_frac(socialdistance1.8.20,.05, replace = TRUE)
socialdistance1.9.20 <- fread('01/09/2020-01-09-social-distancing.csv.gz') %>%
  mutate(day = 9)
socialdistance1.9.sample <- sample_frac(socialdistance1.9.20,.05, replace = TRUE)
socialdistance1.10.20 <- fread('01/10/2020-01-10-social-distancing.csv.gz') %>%
  mutate(day = 10)
socialdistance1.10.sample <- sample_frac(socialdistance1.10.20,.05, replace = TRUE)
socialdistance1.11.20 <- fread('01/11/2020-01-11-social-distancing.csv.gz') %>%
  mutate(day = 11)
socialdistance1.11.sample <- sample_frac(socialdistance1.11.20,.05, replace = TRUE)
socialdistance1.12.20 <- fread('01/12/2020-01-12-social-distancing.csv.gz') %>%
  mutate(day = 12)
socialdistance1.12.sample <- sample_frac(socialdistance1.12.20,.05, replace = TRUE)
socialdistance1.13.20 <- fread('01/13/2020-01-13-social-distancing.csv.gz') %>%
  mutate(day = 13)
socialdistance1.13.sample <- sample_frac(socialdistance1.13.20,.05, replace = TRUE)
socialdistance1.14.20 <- fread('01/14/2020-01-14-social-distancing.csv.gz') %>%
  mutate(day = 14)
socialdistance1.14.sample <- sample_frac(socialdistance1.14.20,.05, replace = TRUE)

socialdistance1.8.sampledf <- as.data.frame(socialdistance1.8.sample)
socialdistance1.9.sampledf <- as.data.frame(socialdistance1.9.sample)
socialdistance1.10.sampledf <- as.data.frame(socialdistance1.10.sample)
socialdistance1.11.sampledf <- as.data.frame(socialdistance1.11.sample)
socialdistance1.12.sampledf <- as.data.frame(socialdistance1.12.sample)
socialdistance1.13.sampledf <- as.data.frame(socialdistance1.13.sample)
socialdistance1.14.sampledf <- as.data.frame(socialdistance1.14.sample)

socialdistancewk2 <- bind_rows(
  socialdistance1.8.sampledf,
  socialdistance1.9.sampledf,
  socialdistance1.10.sampledf,
  socialdistance1.11.sampledf,
  socialdistance1.12.sampledf,
  socialdistance1.13.sampledf,
  socialdistance1.14.sampledf
)
saveRDS(socialdistancewk2, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk2.RDS')


socialdistance1.15.20 <- fread('01/15/2020-01-15-social-distancing.csv.gz') %>%
  mutate(day=15)
socialdistance1.15.sample <- sample_frac(socialdistance1.15.20,.05, replace = TRUE)
socialdistance1.16.20 <- fread('01/16/2020-01-16-social-distancing.csv.gz') %>%
  mutate(day = 16)
socialdistance1.16.sample <- sample_frac(socialdistance1.16.20,.05, replace = TRUE)
socialdistance1.17.20 <- fread('01/17/2020-01-17-social-distancing.csv.gz') %>%
  mutate(day = 17)
socialdistance1.17.sample <- sample_frac(socialdistance1.17.20,.05, replace = TRUE)
socialdistance1.18.20 <- fread('01/18/2020-01-18-social-distancing.csv.gz') %>%
  mutate(day = 18)
socialdistance1.18.sample <- sample_frac(socialdistance1.18.20,.05, replace = TRUE)
socialdistance1.19.20 <- fread('01/19/2020-01-19-social-distancing.csv.gz') %>%
  mutate(day = 19)
socialdistance1.19.sample <- sample_frac(socialdistance1.19.20,.05, replace = TRUE)
socialdistance1.20.20 <- fread('01/20/2020-01-20-social-distancing.csv.gz') %>%
  mutate(day = 20)
socialdistance1.20.sample <- sample_frac(socialdistance1.20.20,.05, replace = TRUE)
socialdistance1.21.20 <- fread('01/21/2020-01-21-social-distancing.csv.gz') %>%
  mutate(day = 21)
socialdistance1.21.sample <- sample_frac(socialdistance1.21.20,.05, replace = TRUE)

socialdistance1.15.sampledf <- as.data.frame(socialdistance1.15.sample)
socialdistance1.16.sampledf <- as.data.frame(socialdistance1.16.sample)
socialdistance1.17.sampledf <- as.data.frame(socialdistance1.17.sample)
socialdistance1.18.sampledf <- as.data.frame(socialdistance1.18.sample)
socialdistance1.19.sampledf <- as.data.frame(socialdistance1.19.sample)
socialdistance1.20.sampledf <- as.data.frame(socialdistance1.20.sample)
socialdistance1.21.sampledf <- as.data.frame(socialdistance1.21.sample)

socialdistancewk3 <- bind_rows(
  socialdistance1.15.sampledf,
  socialdistance1.16.sampledf,
  socialdistance1.17.sampledf,
  socialdistance1.18.sampledf,
  socialdistance1.19.sampledf,
  socialdistance1.20.sampledf,
  socialdistance1.21.sampledf
)

saveRDS(socialdistancewk3, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk3.RDS')



socialdistance1.22.20 <- fread('01/22/2020-01-22-social-distancing.csv.gz') %>%
  mutate(day = 22)
socialdistance1.22.sample <- sample_frac(socialdistance1.22.20,.05, replace = TRUE)
socialdistance1.23.20 <- fread('01/23/2020-01-23-social-distancing.csv.gz') %>%
  mutate(day = 23)
socialdistance1.23.sample <- sample_frac(socialdistance1.23.20,.05, replace = TRUE)
socialdistance1.24.20 <- fread('01/24/2020-01-24-social-distancing.csv.gz') %>%
  mutate(day = 24)
socialdistance1.24.sample <- sample_frac(socialdistance1.24.20,.05, replace = TRUE)
socialdistance1.25.20 <- fread('01/25/2020-01-25-social-distancing.csv.gz') %>%
  mutate(day = 25)
socialdistance1.25.sample <- sample_frac(socialdistance1.25.20,.05, replace = TRUE)
socialdistance1.26.20 <- fread('01/26/2020-01-26-social-distancing.csv.gz') %>%
  mutate(day = 26)
socialdistance1.26.sample <- sample_frac(socialdistance1.26.20,.05, replace = TRUE)
socialdistance1.27.20 <- fread('01/27/2020-01-27-social-distancing.csv.gz') %>%
  mutate(day = 27) # No data reported
socialdistance1.27.sample <- sample_frac(socialdistance1.27.20,.05, replace = TRUE)
socialdistance1.28.20 <- fread('01/28/2020-01-28-social-distancing.csv.gz') %>%
  mutate(day = 28)
socialdistance1.28.sample <- sample_frac(socialdistance1.28.20,.05, replace = TRUE)

socialdistance1.22.sampledf <- as.data.frame(socialdistance1.22.sample)
socialdistance1.23.sampledf <- as.data.frame(socialdistance1.23.sample)
socialdistance1.24.sampledf <- as.data.frame(socialdistance1.24.sample)
socialdistance1.25.sampledf <- as.data.frame(socialdistance1.25.sample)
socialdistance1.26.sampledf <- as.data.frame(socialdistance1.26.sample)
socialdistance1.27.sampledf <- as.data.frame(socialdistance1.27.sample)
socialdistance1.28.sampledf <- as.data.frame(socialdistance1.28.sample)

socialdistancewk4 <- bind_rows(
  socialdistance1.22.sampledf,
  socialdistance1.23.sampledf,
  socialdistance1.24.sampledf,
  socialdistance1.25.sampledf,
  socialdistance1.26.sampledf,
  socialdistance1.28.sampledf
)

saveRDS(socialdistancewk4, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk4.RDS')



socialdistance1.29.20 <- fread('01/29/2020-01-29-social-distancing.csv.gz') %>%
  mutate(day = 29) #Missing Data
socialdistance1.29.sample <- sample_frac(socialdistance1.29.20, .05, replace = TRUE)
socialdistance1.30.20 <- fread('01/30/2020-01-30-social-distancing.csv.gz') %>%
  mutate(day = 30)#Missing Data
socialdistance1.30.sample <- sample_frac(socialdistance1.30.20, .05, replace = TRUE)
socialdistance1.31.20 <- fread('01/31/2020-01-31-social-distancing.csv.gz') %>%
  mutate(day = 31)#Missing Data
socialdistance1.31.sample <- sample_frac(socialdistance1.31.20, .05, replace = TRUE)


## February, 2020
socialdistance2.1.20 <- fread('02/01/2020-02-01-social-distancing.csv.gz') %>%
  mutate(day = 32)
socialdistance2.1.sample <- sample_frac(socialdistance2.1.20, .05, replace = TRUE)
socialdistance2.2.20 <- fread('02/02/2020-02-02-social-distancing.csv.gz')# Missing Data
socialdistance2.2.sample <- sample_frac(socialdistance2.2.20, .05, replace = TRUE)
socialdistance2.3.20 <- fread('02/03/2020-02-03-social-distancing.csv.gz') %>%
  mutate(day = 34)
socialdistance2.3.sample <- sample_frac(socialdistance2.3.20, .05, replace = TRUE) %>%
  mutate(day = 35)
socialdistance2.4.20 <- fread('02/04/2020-02-04-social-distancing.csv.gz') %>%
  mutate(day = 36)
socialdistance2.4.sample <- sample_frac(socialdistance2.4.20, .05, replace = TRUE)

socialdistance1.29.sampledf <- as.data.frame(socialdistance1.29.sample)
socialdistance1.30.sampledf <- as.data.frame(socialdistance1.30.sample)
socialdistance1.31.sampledf <- as.data.frame(socialdistance1.31.sample)
socialdistance2.1.sampledf <- as.data.frame(socialdistance2.1.sample)
socialdistance2.2.sampledf <- as.data.frame(socialdistance2.2.sample)
socialdistance2.3.sampledf <- as.data.frame(socialdistance2.3.sample)
socialdistance2.4.sampledf <- as.data.frame(socialdistance2.4.sample)

socialdistancewk5 <- bind_rows(
  socialdistance2.1.sampledf,
  socialdistance2.3.sampledf,
  socialdistance2.4.sampledf
)

saveRDS(socialdistancewk5, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk5.RDS')



socialdistance2.5.20 <- fread('02/05/2020-02-05-social-distancing.csv.gz') %>%
  mutate(day = 37)
socialdistance2.5.sample <- sample_frac(socialdistance2.5.20, .05, replace = TRUE)
socialdistance2.6.20 <- fread('02/06/2020-02-06-social-distancing.csv.gz') %>%
  mutate(day = 38)
socialdistance2.6.sample <- sample_frac(socialdistance2.6.20, .05, replace = TRUE)
socialdistance2.7.20 <- fread('02/07/2020-02-07-social-distancing.csv.gz') %>%
  mutate(day = 39)
socialdistance2.7.sample <- sample_frac(socialdistance2.7.20, .05, replace = TRUE)
socialdistance2.8.20 <- fread('02/08/2020-02-08-social-distancing.csv.gz') %>%
  mutate(day = 40)
socialdistance2.8.sample <- sample_frac(socialdistance2.8.20, .05, replace = TRUE)
socialdistance2.9.20 <- fread('02/09/2020-02-09-social-distancing.csv.gz') %>%
  mutate(day = 41)
socialdistance2.9.sample <- sample_frac(socialdistance2.9.20, .05, replace = TRUE)
socialdistance2.10.20 <- fread('02/10/2020-02-10-social-distancing.csv.gz') %>%
  mutate(day = 42)
socialdistance2.10.sample <- sample_frac(socialdistance2.10.20, .05, replace = TRUE)
socialdistance2.11.20 <- fread('02/11/2020-02-11-social-distancing.csv.gz') %>%
  mutate(day = 43)
socialdistance2.11.sample <- sample_frac(socialdistance2.11.20, .05, replace = TRUE)

socialdistance2.5.sampledf <- as.data.frame(socialdistance2.5.sample)
socialdistance2.6.sampledf <- as.data.frame(socialdistance2.6.sample)
socialdistance2.7.sampledf <- as.data.frame(socialdistance2.7.sample)
socialdistance2.8.sampledf <- as.data.frame(socialdistance2.8.sample)
socialdistance2.9.sampledf <- as.data.frame(socialdistance2.9.sample)
socialdistance2.10.sampledf <- as.data.frame(socialdistance2.10.sample)
socialdistance2.11.sampledf <- as.data.frame(socialdistance2.11.sample)

socialdistancewk6 <- bind_rows(
  socialdistance2.5.sampledf,
  socialdistance2.6.sampledf,
  socialdistance2.7.sampledf,
  socialdistance2.8.sampledf,
  socialdistance2.9.sampledf,
  socialdistance2.10.sampledf,
  socialdistance2.11.sampledf
)

saveRDS(socialdistancewk6, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk6.RDS')



socialdistance2.12.20 <- fread('02/12/2020-02-12-social-distancing.csv.gz') %>%
  mutate(day = 44)
socialdistance2.12.sample <- sample_frac(socialdistance2.12.20, .05, replace = TRUE)
socialdistance2.13.20 <- fread('02/13/2020-02-13-social-distancing.csv.gz') %>%
  mutate(day = 45)
socialdistance2.13.sample <- sample_frac(socialdistance2.13.20, .05, replace = TRUE)
socialdistance2.14.20 <- fread('02/14/2020-02-14-social-distancing.csv.gz') %>%
  mutate(day = 46)
socialdistance2.14.sample <- sample_frac(socialdistance2.14.20, .05, replace = TRUE)
socialdistance2.15.20 <- fread('02/15/2020-02-15-social-distancing.csv.gz') %>%
  mutate(day = 47)
socialdistance2.15.sample <- sample_frac(socialdistance2.15.20, .05, replace = TRUE)
socialdistance2.16.20 <- fread('02/16/2020-02-16-social-distancing.csv.gz') %>%
  mutate(day = 48)
socialdistance2.16.sample <- sample_frac(socialdistance2.16.20, .05, replace = TRUE)
socialdistance2.17.20 <- fread('02/17/2020-02-17-social-distancing.csv.gz') %>%
  mutate(day = 49)
socialdistance2.17.sample <- sample_frac(socialdistance2.17.20, .05, replace = TRUE)
socialdistance2.18.20 <- fread('02/18/2020-02-18-social-distancing.csv.gz') %>%
  mutate(day = 50)
socialdistance2.18.sample <- sample_frac(socialdistance2.18.20, .05, replace = TRUE)

socialdistance2.12.sampledf <- as.data.frame(socialdistance2.12.sample)
socialdistance2.13.sampledf <- as.data.frame(socialdistance2.13.sample)
socialdistance2.14.sampledf <- as.data.frame(socialdistance2.14.sample)
socialdistance2.15.sampledf <- as.data.frame(socialdistance2.15.sample)
socialdistance2.16.sampledf <- as.data.frame(socialdistance2.16.sample)
socialdistance2.17.sampledf <- as.data.frame(socialdistance2.17.sample)
socialdistance2.18.sampledf <- as.data.frame(socialdistance2.18.sample)

socialdistancewk7 <- bind_rows(
  socialdistance2.12.sampledf,
  socialdistance2.13.sampledf,
  socialdistance2.14.sampledf,
  socialdistance2.15.sampledf,
  socialdistance2.16.sampledf,
  socialdistance2.17.sampledf,
  socialdistance2.18.sampledf
)

saveRDS(socialdistancewk7, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk7.RDS')



socialdistance2.19.20 <- fread('02/19/2020-02-19-social-distancing.csv.gz') %>%
  mutate(day = 51)
socialdistance2.19.sample <- sample_frac(socialdistance2.19.20, .05, replace = TRUE)
socialdistance2.20.20 <- fread('02/20/2020-02-20-social-distancing.csv.gz') %>%
  mutate(day = 52)
socialdistance2.20.sample <- sample_frac(socialdistance2.20.20, .05, replace = TRUE)
socialdistance2.21.20 <- fread('02/21/2020-02-21-social-distancing.csv.gz') %>%
  mutate(day = 53)
socialdistance2.21.sample <- sample_frac(socialdistance2.21.20, .05, replace = TRUE)
socialdistance2.22.20 <- fread('02/22/2020-02-22-social-distancing.csv.gz') %>%
  mutate(day = 54)
socialdistance2.22.sample <- sample_frac(socialdistance2.22.20, .05, replace = TRUE)
socialdistance2.23.20 <- fread('02/23/2020-02-23-social-distancing.csv.gz') %>%
  mutate(day = 55)
socialdistance2.23.sample <- sample_frac(socialdistance2.23.20, .05, replace = TRUE)
socialdistance2.24.20 <- fread('02/24/2020-02-24-social-distancing.csv.gz') %>%
  mutate(day = 56)
socialdistance2.24.sample <- sample_frac(socialdistance2.24.20, .05, replace = TRUE)
socialdistance2.25.20 <- fread('02/25/2020-02-25-social-distancing.csv.gz') %>%
  mutate(day = 57)
socialdistance2.25.sample <- sample_frac(socialdistance2.25.20, .05, replace = TRUE)

socialdistance2.19.sampledf <- as.data.frame(socialdistance2.19.sample)
socialdistance2.20.sampledf <- as.data.frame(socialdistance2.20.sample)
socialdistance2.21.sampledf <- as.data.frame(socialdistance2.21.sample)
socialdistance2.22.sampledf <- as.data.frame(socialdistance2.22.sample)
socialdistance2.23.sampledf <- as.data.frame(socialdistance2.23.sample)
socialdistance2.24.sampledf <- as.data.frame(socialdistance2.24.sample)
socialdistance2.25.sampledf <- as.data.frame(socialdistance2.25.sample)

socialdistancewk8 <- bind_rows(
  socialdistance2.19.sampledf,
  socialdistance2.20.sampledf,
  socialdistance2.21.sampledf,
  socialdistance2.22.sampledf,
  socialdistance2.23.sampledf,
  socialdistance2.25.sampledf
)

saveRDS(socialdistancewk8, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk8.RDS')





socialdistance2.26.20 <- fread('02/26/2020-02-26-social-distancing.csv.gz') %>%
  mutate(day = 58)
socialdistance2.26.sample <- sample_frac(socialdistance2.26.20, .05, replace = TRUE)
socialdistance2.27.20 <- fread('02/27/2020-02-27-social-distancing.csv.gz') %>%
  mutate(day = 59)
socialdistance2.27.sample <- sample_frac(socialdistance2.27.20, .05, replace = TRUE)
socialdistance2.28.20 <- fread('02/28/2020-02-28-social-distancing.csv.gz') %>%
  mutate(day = 60)
socialdistance2.28.sample <- sample_frac(socialdistance2.28.20, .05, replace = TRUE)
socialdistance2.29.20 <- fread('02/29/2020-02-29-social-distancing.csv.gz') %>%
  mutate(day = 61)
socialdistance2.29.sample <- sample_frac(socialdistance2.29.20, .05, replace = TRUE)

## March, 2020
socialdistance3.1.20 <- fread('03/01/2020-03-01-social-distancing.csv.gz') %>%
  mutate(day = 62)
socialdistance3.1.sample <- sample_frac(socialdistance3.1.20, .05, replace = TRUE)
socialdistance3.2.20 <- fread('03/02/2020-03-02-social-distancing.csv.gz') %>%
  mutate(day = 63)
socialdistance3.2.sample <- sample_frac(socialdistance3.2.20, .05, replace = TRUE)
socialdistance3.3.20 <- fread('03/03/2020-03-03-social-distancing.csv.gz') %>%
  mutate(day = 64)
socialdistance3.3.sample <- sample_frac(socialdistance3.3.20, .05, replace = TRUE)

socialdistance2.26.sampledf <- as.data.frame(socialdistance2.26.sample)
socialdistance2.27.sampledf <- as.data.frame(socialdistance2.27.sample)
socialdistance2.28.sampledf <- as.data.frame(socialdistance2.28.sample)
socialdistance2.29.sampledf <- as.data.frame(socialdistance2.29.sample)
socialdistance3.1.sampledf <- as.data.frame(socialdistance3.1.sample)
socialdistance3.2.sampledf <- as.data.frame(socialdistance3.2.sample)
socialdistance3.3.sampledf <- as.data.frame(socialdistance3.3.sample)

socialdistancewk9 <- bind_rows(
  socialdistance2.26.sampledf,
  socialdistance2.27.sampledf,
  socialdistance2.28.sampledf,
  socialdistance2.29.sampledf,
  socialdistance3.1.sampledf,
  socialdistance3.2.sampledf,
  socialdistance3.3.sampledf
)

saveRDS(socialdistancewk9, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk9.RDS')






socialdistance3.4.20 <- fread('03/04/2020-03-04-social-distancing.csv.gz') %>%
  mutate(day = 65)
socialdistance3.4.sample <- sample_frac(socialdistance3.4.20, .05, replace = TRUE)
socialdistance3.5.20 <- fread('03/05/2020-03-05-social-distancing.csv.gz') %>%
  mutate(day = 66) 
socialdistance3.5.sample <- sample_frac(socialdistance3.5.20, .05, replace = TRUE)
socialdistance3.6.20 <- fread('03/06/2020-03-06-social-distancing.csv.gz') %>%
  mutate(day = 67)
socialdistance3.6.sample <- sample_frac(socialdistance3.6.20, .05, replace = TRUE)
socialdistance3.7.20 <- fread('03/07/2020-03-07-social-distancing.csv.gz') %>%
  mutate(day = 68)
socialdistance3.7.sample <- sample_frac(socialdistance3.7.20, .05, replace = TRUE)
socialdistance3.8.20 <- fread('03/08/2020-03-08-social-distancing.csv.gz') %>%
  mutate(day = 69)
socialdistance3.8.sample <- sample_frac(socialdistance3.8.20, .05, replace = TRUE)
socialdistance3.9.20 <- fread('03/09/2020-03-09-social-distancing.csv.gz') %>%
  mutate(day = 70)
socialdistance3.9.sample <- sample_frac(socialdistance3.9.20, .05, replace = TRUE)
socialdistance3.10.20 <- fread('03/10/2020-03-10-social-distancing.csv.gz') %>%
  mutate(day = 71)
socialdistance3.10.sample <- sample_frac(socialdistance3.10.20, .05, replace = TRUE)

socialdistance3.4.sampledf <- as.data.frame(socialdistance3.4.sample)
socialdistance3.5.sampledf <- as.data.frame(socialdistance3.5.sample)
socialdistance3.6.sampledf <- as.data.frame(socialdistance3.6.sample)
socialdistance3.7.sampledf <- as.data.frame(socialdistance3.7.sample)
socialdistance3.8.sampledf <- as.data.frame(socialdistance3.8.sample)
socialdistance3.9.sampledf <- as.data.frame(socialdistance3.9.sample)
socialdistance3.10.sampledf <- as.data.frame(socialdistance3.10.sample)

socialdistancewk10 <- bind_rows(
  socialdistance3.4.sampledf,
  socialdistance3.5.sampledf,
  socialdistance3.6.sampledf,
  socialdistance3.7.sampledf,
  socialdistance3.8.sampledf,
  socialdistance3.9.sampledf,
  socialdistance3.10.sampledf
)

saveRDS(socialdistancewk10, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk10.RDS')




socialdistance3.11.20 <- fread('03/11/2020-03-11-social-distancing.csv.gz') %>%
  mutate(day = 72)
socialdistance3.11.sample <- sample_frac(socialdistance3.11.20, .05, replace = TRUE)
socialdistance3.12.20 <- fread('03/12/2020-03-12-social-distancing.csv.gz') %>%
  mutate(day = 73)
socialdistance3.12.sample <- sample_frac(socialdistance3.12.20, .05, replace = TRUE)
socialdistance3.13.20 <- fread('03/13/2020-03-13-social-distancing.csv.gz') %>%
  mutate(day = 74)
socialdistance3.13.sample <- sample_frac(socialdistance3.13.20, .05, replace = TRUE)
socialdistance3.14.20 <- fread('03/14/2020-03-14-social-distancing.csv.gz') %>%
  mutate(day = 75)
socialdistance3.14.sample <- sample_frac(socialdistance3.14.20, .05, replace = TRUE)
socialdistance3.15.20 <- fread('03/15/2020-03-15-social-distancing.csv.gz') %>%
  mutate(day = 76)
socialdistance3.15.sample <- sample_frac(socialdistance3.15.20, .05, replace = TRUE)
socialdistance3.16.20 <- fread('03/16/2020-03-16-social-distancing.csv.gz') %>%
  mutate(day = 77)
socialdistance3.16.sample <- sample_frac(socialdistance3.16.20, .05, replace = TRUE)
socialdistance3.17.20 <- fread('03/17/2020-03-17-social-distancing.csv.gz') %>%
  mutate(day = 78)
socialdistance3.17.sample <- sample_frac(socialdistance3.17.20, .05, replace = TRUE)

socialdistance3.11.sampledf <- as.data.frame(socialdistance3.11.sample)
socialdistance3.12.sampledf <- as.data.frame(socialdistance3.12.sample)
socialdistance3.13.sampledf <- as.data.frame(socialdistance3.13.sample)
socialdistance3.14.sampledf <- as.data.frame(socialdistance3.14.sample)
socialdistance3.15.sampledf <- as.data.frame(socialdistance3.15.sample)
socialdistance3.16.sampledf <- as.data.frame(socialdistance3.16.sample)
socialdistance3.17.sampledf <- as.data.frame(socialdistance3.17.sample)

socialdistancewk11 <- bind_rows(
  socialdistance3.11.sampledf,
  socialdistance3.12.sampledf,
  socialdistance3.13.sampledf,
  socialdistance3.14.sampledf,
  socialdistance3.15.sampledf,
  socialdistance3.16.sampledf,
  socialdistance3.17.sampledf
)

saveRDS(socialdistancewk11, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk11.RDS')



socialdistance3.18.20 <- fread('03/18/2020-03-18-social-distancing.csv.gz') %>%
  mutate(day =79)
socialdistance3.18.sample <- sample_frac(socialdistance3.18.20, .05, replace = TRUE)
socialdistance3.19.20 <- fread('03/19/2020-03-19-social-distancing.csv.gz') %>%
  mutate(day =80)
socialdistance3.19.sample <- sample_frac(socialdistance3.19.20, .05, replace = TRUE)
socialdistance3.20.20 <- fread('03/20/2020-03-20-social-distancing.csv.gz') %>%
  mutate(day =90)
socialdistance3.20.sample <- sample_frac(socialdistance3.20.20, .05, replace = TRUE)
socialdistance3.21.20 <- fread('03/21/2020-03-21-social-distancing.csv.gz') %>%
  mutate(day=91)
socialdistance3.21.sample <- sample_frac(socialdistance3.21.20, .05, replace = TRUE)
socialdistance3.22.20 <- fread('03/22/2020-03-22-social-distancing.csv.gz') %>%
  mutate(day =92)
socialdistance3.22.sample <- sample_frac(socialdistance3.22.20, .05, replace = TRUE)
socialdistance3.23.20 <- fread('03/23/2020-03-23-social-distancing.csv.gz') %>%
  mutate(day =93)
socialdistance3.23.sample <- sample_frac(socialdistance3.23.20, .05, replace = TRUE)
socialdistance3.24.20 <- fread('03/24/2020-03-24-social-distancing.csv.gz') %>%
  mutate(day =94)
socialdistance3.24.sample <- sample_frac(socialdistance3.24.20, .05, replace = TRUE)

socialdistance3.18.sampledf <- as.data.frame(socialdistance3.18.sample)
socialdistance3.19.sampledf <- as.data.frame(socialdistance3.19.sample)
socialdistance3.20.sampledf <- as.data.frame(socialdistance3.20.sample)
socialdistance3.21.sampledf <- as.data.frame(socialdistance3.21.sample)
socialdistance3.22.sampledf <- as.data.frame(socialdistance3.22.sample)
socialdistance3.23.sampledf <- as.data.frame(socialdistance3.23.sample)
socialdistance3.24.sampledf <- as.data.frame(socialdistance3.24.sample)

socialdistancewk12 <- bind_rows(
  socialdistance3.18.sampledf,
  socialdistance3.19.sampledf,
  socialdistance3.20.sampledf,
  socialdistance3.21.sampledf,
  socialdistance3.22.sampledf,
  socialdistance3.23.sampledf,
  socialdistance3.24.sampledf
)

saveRDS(socialdistancewk12, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk12.RDS')



socialdistance3.25.20 <- fread('03/25/2020-03-25-social-distancing.csv.gz') %>%
  mutate(day = 95)
socialdistance3.25.sample <- sample_frac(socialdistance3.25.20, .05, replace = TRUE)
socialdistance3.26.20 <- fread('03/26/2020-03-26-social-distancing.csv.gz') %>%
  mutate(day = 96)
socialdistance3.26.sample <- sample_frac(socialdistance3.26.20, .05, replace = TRUE)
socialdistance3.27.20 <- fread('03/27/2020-03-27-social-distancing.csv.gz') %>%
  mutate(day = 97)
socialdistance3.27.sample <- sample_frac(socialdistance3.27.20, .05, replace = TRUE)
socialdistance3.28.20 <- fread('03/28/2020-03-28-social-distancing.csv.gz') %>%
  mutate(day = 98)
socialdistance3.28.sample <- sample_frac(socialdistance3.28.20, .05, replace = TRUE)
socialdistance3.29.20 <- fread('03/29/2020-03-29-social-distancing.csv.gz') %>%
  mutate(day = 99)
socialdistance3.29.sample <- sample_frac(socialdistance3.29.20, .05, replace = TRUE)
socialdistance3.30.20 <- fread('03/30/2020-03-30-social-distancing.csv.gz') %>%
  mutate(day = 100)
socialdistance3.30.sample <- sample_frac(socialdistance3.30.20, .05, replace = TRUE)
socialdistance3.31.20 <- fread('03/31/2020-03-31-social-distancing.csv.gz') %>%
  mutate(day = 101)
socialdistance3.31.sample <- sample_frac(socialdistance3.31.20, .05, replace = TRUE)

socialdistance3.25.sampledf <- as.data.frame(socialdistance3.25.sample)
socialdistance3.26.sampledf <- as.data.frame(socialdistance3.26.sample)
socialdistance3.27.sampledf <- as.data.frame(socialdistance3.27.sample)
socialdistance3.28.sampledf <- as.data.frame(socialdistance3.28.sample)
socialdistance3.29.sampledf <- as.data.frame(socialdistance3.29.sample)
socialdistance3.30.sampledf <- as.data.frame(socialdistance3.30.sample)
socialdistance3.31.sampledf <- as.data.frame(socialdistance3.31.sample)

socialdistancewk13 <- bind_rows(
  socialdistance3.25.sampledf,
  socialdistance3.26.sampledf,
  socialdistance3.27.sampledf,
  socialdistance3.27.sampledf,
  socialdistance3.28.sampledf,
  socialdistance3.29.sampledf,
  socialdistance3.30.sampledf,
  socialdistance3.31.sampledf
)

saveRDS(socialdistancewk13, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk13.RDS')






## April, 2020
socialdistance4.1.20 <- fread('04/01/2020-04-01-social-distancing.csv.gz') %>%
  mutate(day = 102)
socialdistance4.1.sample <- sample_frac(socialdistance4.1.20, .05, replace = TRUE)
socialdistance4.2.20 <- fread('04/02/2020-04-02-social-distancing.csv.gz') %>%
  mutate(day = 103)
socialdistance4.2.sample <- sample_frac(socialdistance4.2.20, .05, replace = TRUE)
socialdistance4.3.20 <- fread('04/03/2020-04-03-social-distancing.csv.gz') %>%
  mutate(day = 104)
socialdistance4.3.sample <- sample_frac(socialdistance4.3.20, .05, replace = TRUE)
socialdistance4.4.20 <- fread('04/04/2020-04-04-social-distancing.csv.gz') %>%
  mutate(day = 105)
socialdistance4.4.sample <- sample_frac(socialdistance4.4.20, .05, replace = TRUE)
socialdistance4.5.20 <- fread('04/05/2020-04-05-social-distancing.csv.gz') %>%
  mutate(day = 106)
socialdistance4.5.sample <- sample_frac(socialdistance4.5.20, .05, replace = TRUE)
socialdistance4.6.20 <- fread('04/06/2020-04-06-social-distancing.csv.gz') %>%
  mutate(day = 107)
socialdistance4.6.sample <- sample_frac(socialdistance4.6.20, .05, replace = TRUE)
socialdistance4.7.20 <- fread('04/07/2020-04-07-social-distancing.csv.gz') %>%
  mutate(day = 108)
socialdistance4.7.sample <- sample_frac(socialdistance4.7.20, .05, replace = TRUE)

socialdistance4.1.sampledf <- as.data.frame(socialdistance4.1.sample)
socialdistance4.2.sampledf <- as.data.frame(socialdistance4.2.sample)
socialdistance4.3.sampledf <- as.data.frame(socialdistance4.3.sample)
socialdistance4.4.sampledf <- as.data.frame(socialdistance4.4.sample)
socialdistance4.5.sampledf <- as.data.frame(socialdistance4.5.sample)
socialdistance4.6.sampledf <- as.data.frame(socialdistance4.6.sample)
socialdistance4.7.sampledf <- as.data.frame(socialdistance4.7.sample)

socialdistancewk14 <- bind_rows(
  socialdistance4.1.sampledf,
  socialdistance4.2.sampledf,
  socialdistance4.3.sampledf,
  socialdistance4.4.sampledf,
  socialdistance4.5.sampledf,
  socialdistance4.6.sampledf,
  socialdistance4.7.sampledf
)

saveRDS(socialdistancewk14, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk14.RDS')





socialdistance4.8.20 <- fread('04/08/2020-04-08-social-distancing.csv.gz') %>%
  mutate(day = 109)
socialdistance4.8.sample <- sample_frac(socialdistance4.8.20, .05, replace = TRUE)
socialdistance4.9.20 <- fread('04/09/2020-04-09-social-distancing.csv.gz') %>%
  mutate(day = 110)
socialdistance4.9.sample <- sample_frac(socialdistance4.9.20, .05, replace = TRUE)
socialdistance4.10.20 <- fread('04/10/2020-04-10-social-distancing.csv.gz') %>%
  mutate(day = 111)
socialdistance4.10.sample <- sample_frac(socialdistance4.10.20, .05, replace = TRUE)
socialdistance4.11.20 <- fread('04/11/2020-04-11-social-distancing.csv.gz') %>%
  mutate(day = 112)
socialdistance4.11.sample <- sample_frac(socialdistance4.11.20, .05, replace = TRUE)
socialdistance4.12.20 <- fread('04/12/2020-04-12-social-distancing.csv.gz') %>%
  mutate(day =113)
socialdistance4.12.sample <- sample_frac(socialdistance4.12.20, .05, replace = TRUE)
socialdistance4.13.20 <- fread('04/13/2020-04-13-social-distancing.csv.gz') %>%
  mutate(day = 114)
socialdistance4.13.sample <- sample_frac(socialdistance4.13.20, .05, replace = TRUE)
socialdistance4.14.20 <- fread('04/14/2020-04-14-social-distancing.csv.gz') %>%
  mutate(day = 115)
socialdistance4.14.sample <- sample_frac(socialdistance4.14.20, .05, replace = TRUE)

socialdistance4.8.sampledf <- as.data.frame(socialdistance4.8.sample)
socialdistance4.9.sampledf <- as.data.frame(socialdistance4.9.sample)
socialdistance4.10.sampledf <- as.data.frame(socialdistance4.10.sample)
socialdistance4.11.sampledf <- as.data.frame(socialdistance4.11.sample)
socialdistance4.12.sampledf <- as.data.frame(socialdistance4.12.sample)
socialdistance4.13.sampledf <- as.data.frame(socialdistance4.13.sample)
socialdistance4.14.sampledf <- as.data.frame(socialdistance4.14.sample)

socialdistancewk15 <- bind_rows(
  socialdistance4.8.sampledf,
  socialdistance4.9.sampledf,
  socialdistance4.10.sampledf,
  socialdistance4.11.sampledf,
  socialdistance4.12.sampledf,
  socialdistance4.13.sampledf,
  socialdistance4.14.sampledf
)

saveRDS(socialdistancewk15, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk15.RDS')





socialdistance4.15.20 <- fread('04/15/2020-04-15-social-distancing.csv.gz') %>%
  mutate(day = 116)
socialdistance4.15.sample <- sample_frac(socialdistance4.15.20, .05, replace = TRUE)
socialdistance4.16.20 <- fread('04/16/2020-04-16-social-distancing.csv.gz') %>%
  mutate(day = 117)
socialdistance4.16.sample <- sample_frac(socialdistance4.16.20, .05, replace = TRUE)
socialdistance4.17.20 <- fread('04/17/2020-04-17-social-distancing.csv.gz') %>%
  mutate(day = 118)
socialdistance4.17.sample <- sample_frac(socialdistance4.17.20, .05, replace = TRUE)
socialdistance4.18.20 <- fread('04/18/2020-04-18-social-distancing.csv.gz') %>%
  mutate(day = 119)
socialdistance4.18.sample <- sample_frac(socialdistance4.18.20, .05, replace = TRUE)
socialdistance4.19.20 <- fread('04/19/2020-04-19-social-distancing.csv.gz') %>%
  mutate(day = 120)
socialdistance4.19.sample <- sample_frac(socialdistance4.19.20, .05, replace = TRUE)
socialdistance4.20.20 <- fread('04/20/2020-04-20-social-distancing.csv.gz') %>%
  mutate(day = 121)
socialdistance4.20.sample <- sample_frac(socialdistance4.20.20, .05, replace = TRUE)
socialdistance4.21.20 <- fread('04/21/2020-04-21-social-distancing.csv.gz') %>%
  mutate(day = 122)
socialdistance4.21.sample <- sample_frac(socialdistance4.21.20, .05, replace = TRUE)

socialdistance4.15.sampledf <- as.data.frame(socialdistance4.15.sample)
socialdistance4.16.sampledf <- as.data.frame(socialdistance4.16.sample)
socialdistance4.17.sampledf <- as.data.frame(socialdistance4.17.sample)
socialdistance4.18.sampledf <- as.data.frame(socialdistance4.18.sample)
socialdistance4.19.sampledf <- as.data.frame(socialdistance4.19.sample)
socialdistance4.20.sampledf <- as.data.frame(socialdistance4.20.sample)
socialdistance4.21.sampledf <- as.data.frame(socialdistance4.21.sample)

socialdistancewk16 <- bind_rows(
  socialdistance4.15.sampledf,
  socialdistance4.16.sampledf,
  socialdistance4.17.sampledf,
  socialdistance4.18.sampledf,
  socialdistance4.19.sampledf,
  socialdistance4.20.sampledf,
  socialdistance4.21.sampledf
)

saveRDS(socialdistancewk16, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk16.RDS')




socialdistance4.22.20 <- fread('04/22/2020-04-22-social-distancing.csv.gz') %>%
  mutate(day = 123)
socialdistance4.22.sample <- sample_frac(socialdistance4.22.20, .05, replace = TRUE)
socialdistance4.23.20 <- fread('04/23/2020-04-23-social-distancing.csv.gz') %>%
  mutate(day = 124)
socialdistance4.23.sample <- sample_frac(socialdistance4.23.20, .05, replace = TRUE)
socialdistance4.24.20 <- fread('04/24/2020-04-24-social-distancing.csv.gz') %>%
  mutate(day = 125)
socialdistance4.24.sample <- sample_frac(socialdistance4.24.20, .05, replace = TRUE)
socialdistance4.25.20 <- fread('04/25/2020-04-25-social-distancing.csv.gz') %>%
  mutate(day = 126)
socialdistance4.25.sample <- sample_frac(socialdistance4.25.20, .05, replace = TRUE)
socialdistance4.26.20 <- fread('04/26/2020-04-26-social-distancing.csv.gz') %>%
  mutate(day = 127)
socialdistance4.26.sample <- sample_frac(socialdistance4.26.20, .05, replace = TRUE)
socialdistance4.27.20 <- fread('04/27/2020-04-27-social-distancing.csv.gz') %>%
  mutate(day = 128)
socialdistance4.27.sample <- sample_frac(socialdistance4.27.20, .05, replace = TRUE)
socialdistance4.28.20 <- fread('04/28/2020-04-28-social-distancing.csv.gz') %>%
  mutate(day = 129)
socialdistance4.28.sample <- sample_frac(socialdistance4.28.20, .05, replace = TRUE)

socialdistance4.22.sampledf <- as.data.frame(socialdistance4.22.sample)
socialdistance4.23.sampledf <- as.data.frame(socialdistance4.23.sample)
socialdistance4.24.sampledf <- as.data.frame(socialdistance4.24.sample)
socialdistance4.25.sampledf <- as.data.frame(socialdistance4.25.sample)
socialdistance4.26.sampledf <- as.data.frame(socialdistance4.26.sample)
socialdistance4.27.sampledf <- as.data.frame(socialdistance4.27.sample)
socialdistance4.28.sampledf <- as.data.frame(socialdistance4.28.sample)

socialdistancewk17 <- bind_rows(
  socialdistance4.22.sampledf,
  socialdistance4.23.sampledf,
  socialdistance4.24.sampledf,
  socialdistance4.25.sampledf,
  socialdistance4.26.sampledf,
  socialdistance4.27.sampledf,
  socialdistance4.28.sampledf
)

saveRDS(socialdistancewk17, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk17.RDS')




socialdistance4.29.20 <- fread('04/29/2020-04-29-social-distancing.csv.gz') %>%
  mutate(day = 130)
socialdistance4.29.sample <- sample_frac(socialdistance4.29.20, .05, replace = TRUE)
socialdistance4.30.20 <- fread('04/30/2020-04-30-social-distancing.csv.gz') %>%
  mutate(day = 131)
socialdistance4.30.sample <- sample_frac(socialdistance4.30.20, .05, replace = TRUE)


## May, 2020
socialdistance5.1.20 <- fread('05/01/2020-05-01-social-distancing.csv.gz') %>%
  mutate(day = 132)
socialdistance5.1.sample <- sample_frac(socialdistance5.1.20, .05, replace = TRUE)
socialdistance5.2.20 <- fread('05/02/2020-05-02-social-distancing.csv.gz') %>%
  mutate(day = 133)
socialdistance5.2.sample <- sample_frac(socialdistance5.2.20, .05, replace = TRUE)
socialdistance5.3.20 <- fread('05/03/2020-05-03-social-distancing.csv.gz') %>%
  mutate(day = 134)
socialdistance5.3.sample <- sample_frac(socialdistance5.3.20, .05, replace = TRUE)
socialdistance5.4.20 <- fread('05/04/2020-05-04-social-distancing.csv.gz') %>%
  mutate(day = 135)
socialdistance5.4.sample <- sample_frac(socialdistance5.4.20, .05, replace = TRUE)
socialdistance5.5.20 <- fread('05/05/2020-05-05-social-distancing.csv.gz') %>%
  mutate(day = 136)
socialdistance5.5.sample <- sample_frac(socialdistance5.5.20, .05, replace = TRUE)

socialdistance4.29.sampledf <- as.data.frame(socialdistance4.29.sample)
socialdistance4.30.sampledf <- as.data.frame(socialdistance4.30.sample)
socialdistance5.1.sampledf <- as.data.frame(socialdistance5.1.sample)
socialdistance5.2.sampledf <- as.data.frame(socialdistance5.2.sample)
socialdistance5.3.sampledf <- as.data.frame(socialdistance5.3.sample)
socialdistance5.4.sampledf <- as.data.frame(socialdistance5.4.sample)
socialdistance5.5.sampledf <- as.data.frame(socialdistance5.5.sample)

socialdistancewk18 <- bind_rows(
  socialdistance4.29.sampledf,
  socialdistance4.30.sampledf,
  socialdistance5.1.sampledf,
  socialdistance5.2.sampledf,
  socialdistance5.3.sampledf,
  socialdistance5.4.sampledf,
  socialdistance5.5.sampledf
)

saveRDS(socialdistancewk18, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk18.RDS')



socialdistance5.6.20 <- fread('05/06/2020-05-06-social-distancing.csv.gz') %>%
  mutate(day = 137)
socialdistance5.6.sample <- sample_frac(socialdistance5.6.20, .05, replace = TRUE)
socialdistance5.7.20 <- fread('05/07/2020-05-07-social-distancing.csv.gz') %>%
  mutate(day = 138)
socialdistance5.7.sample <- sample_frac(socialdistance5.7.20, .05, replace = TRUE)
socialdistance5.8.20 <- fread('05/08/2020-05-08-social-distancing.csv.gz') %>%
  mutate(day = 139)
socialdistance5.8.sample <- sample_frac(socialdistance5.8.20, .05, replace = TRUE)
socialdistance5.9.20 <- fread('05/09/2020-05-09-social-distancing.csv.gz') %>%
  mutate(day = 140)
socialdistance5.9.sample <- sample_frac(socialdistance5.9.20, .05, replace = TRUE)
socialdistance5.10.20 <- fread('05/10/2020-05-10-social-distancing.csv.gz') %>%
  mutate(day = 141)
socialdistance5.10.sample <- sample_frac(socialdistance5.10.20, .05, replace = TRUE)
socialdistance5.11.20 <- fread('05/11/2020-05-11-social-distancing.csv.gz') %>%
  mutate(day = 142)
socialdistance5.11.sample <- sample_frac(socialdistance5.11.20, .05, replace = TRUE)
socialdistance5.12.20 <- fread('05/12/2020-05-12-social-distancing.csv.gz') %>%
  mutate(day = 143)
socialdistance5.12.sample <- sample_frac(socialdistance5.12.20, .05, replace = TRUE)

socialdistance5.6.sampledf <- as.data.frame(socialdistance5.6.sample)
socialdistance5.7.sampledf <- as.data.frame(socialdistance5.7.sample)
socialdistance5.8.sampledf <- as.data.frame(socialdistance5.8.sample)
socialdistance5.9.sampledf <- as.data.frame(socialdistance5.9.sample)
socialdistance5.10.sampledf <- as.data.frame(socialdistance5.10.sample)
socialdistance5.11.sampledf <- as.data.frame(socialdistance5.11.sample)
socialdistance5.12.sampledf <- as.data.frame(socialdistance5.12.sample)

socialdistancewk19 <- bind_rows(
  socialdistance5.6.sampledf,
  socialdistance5.7.sampledf,
  socialdistance5.8.sampledf,
  socialdistance5.9.sampledf,
  socialdistance5.10.sampledf,
  socialdistance5.11.sampledf,
  socialdistance5.12.sampledf
)

saveRDS(socialdistancewk19, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk19.RDS')

############     Combining it all into a big dataset   ##############
#load in all the weekly bootstrapped datasets
socialdistancewk1 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk1.RDS')
socialdistancewk2 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk2.RDS')
socialdistancewk3 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk3.RDS')
socialdistancewk4 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk4.RDS')
socialdistancewk5 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk5.RDS')
socialdistancewk6 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk6.RDS')
socialdistancewk7 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk7.RDS')
socialdistancewk8 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk8.RDS')
socialdistancewk9 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk9.RDS')
socialdistancewk10 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk10.RDS')
socialdistancewk11 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk11.RDS')
socialdistancewk12 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk12.RDS')
socialdistancewk13 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk13.RDS')
socialdistancewk14 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk14.RDS')
socialdistancewk15 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk15.RDS')
socialdistancewk16 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk16.RDS')
socialdistancewk17 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk17.RDS')
socialdistancewk18 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk18.RDS')
socialdistancewk19 <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancewk19.RDS')

# combine all of the weekly sampled data into one data frame

socialdistancesampled <- bind_rows(
  socialdistancewk1 %>%
    mutate(week =1),
  socialdistancewk2 %>%
    mutate(week = 2),
  socialdistancewk3 %>%
    mutate(week = 3),
  socialdistancewk4 %>%
    mutate(week = 4),
  socialdistancewk5 %>%
    mutate(week = 5),
  socialdistancewk6 %>%
    mutate(week = 6),
  socialdistancewk7 %>%
    mutate(week = 7),
  socialdistancewk8 %>%
    mutate(week = 8),
  socialdistancewk9 %>%
    mutate(week = 9),
  socialdistancewk10 %>%
    mutate(week = 10),
  socialdistancewk11 %>%
    mutate(week = 11),
  socialdistancewk12 %>%
    mutate(week = 12),
  socialdistancewk13 %>%
    mutate(week = 13),
  socialdistancewk14 %>%
    mutate(week = 14),
  socialdistancewk15 %>%
    mutate(week = 15),
  socialdistancewk16 %>%
    mutate(week = 16),
  socialdistancewk17 %>%
    mutate(week = 17),
  socialdistancewk18 %>%
    mutate(week = 18),
  socialdistancewk19 %>%
    mutate(week = 19)
) #mutate here creates a week variable and labels it by what week of the year it is. This helps add another layer to the temporality of our dataset.

#save one big dataset of all the sampled data.
saveRDS(socialdistancesampled, '~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancesampled.RDS') 






#Check if it works
data <- readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/socialdistancesampled.RDS')
View(data) # cool it did!


################################################
#        ADD FIPS CODE TO SD DATASET          #
###############################################


# Census data not connected to social distancing data... Lets try this

# Organize by county Code from Census dataset

pacman::p_load(data.table)
pacman::p_load(tidyverse)
pacman::p_load(here)
pacman::p_load(doParallel)
doParallel::registerDoParallel(cores = 8)


# file path ---------------------------------------------------------------

# adjust accordingly. here I assume the data is in a folder called data
# which is located in your R working directory
datain <- here::here("AWS Data")


# other inputs ------------------------------------------------------------

startM <- 1 # which month start
endM <- 5 # which month end

# which columns to read in 
col_names <- c(
  "origin_census_block_group",
  "date_range_start",
  "date_range_end",
  "device_count",
  "distance_traveled_from_home",
  # "bucketed_distance_traveled",
  # "median_dwell_at_bucketed_distance_traveled",
  "completely_home_device_count",
  "median_home_dwell_time",
  # "bucketed_home_dwell_time",
  # "at_home_by_each_hour",
  "part_time_work_behavior_devices",
  "full_time_work_behavior_devices",
  # "destination_cbgs",
  "delivery_behavior_devices",
  "median_non_home_dwell_time",
  "candidate_device_count",
  # "bucketed_away_from_home_time",
  # "bucketed_percentage_time_home"
  "median_percentage_time_home"
)

# get census block groups -------------------------------------------------
setwd("~/Dropbox/Spatial COVID 19")
library(here)
library(data.table)
library(tidyverse)
library(doParallel)
doParallel::registerDoParallel(cores = 8)
# download file from https://docs.safegraph.com/docs/open-census-data
cbg <- fread("AWS Data/safegraph_open_census_data/metadata/cbg_fips_codes.csv",
             keepLeadingZeros = TRUE)

# check that all state fips are 2 and county fips are 3 characters
nchar(cbg$state_fips) %>% table
nchar(cbg$county_fips) %>% table

# update some codes
# source: https://www.cdc.gov/nchs/nvss/bridged_race/county_geography-_changes2015.pdf
cbg[state_fips == "02" & county_fips == "270", `:=`(county_fips = 158,
                                                    county = "Kusilvak Census Area")]
cbg[state_fips == "46" & county_fips == "113", `:=`(county_fips = 102,
                                                    county = "Oglala Lakota County")]

cbg[, fips := stringr::str_c(cbg$state_fips, cbg$county_fips)]

# check all fips are 5 characters long
cbg[,table(nchar(fips))]

# for faster data.table joins
setkey(cbg, "fips")



sampledsd <- data.table(readRDS('/Users/damonroberts/Dropbox/Spatial Covid 19/Cleaned Data/socialdistancesampled.RDS'))
sampledsd[, table(nchar(origin_census_block_group))]
sampledsd[, fips:=stringr::str_sub(origin_census_block_group,1,5)]
censusandsampledsd <- merge(x = sampledsd, y = cbg, by = 'fips')

censusattributes <- data.table(read.csv('safegraph_open_census_data/metadata/cbg_field_descriptions.csv'))
#Starting to push my RAM again. Save the data and clean the environment then reload the minimum.

saveRDS(censusandsampledsd, '~/Dropbox/Spatial COVID 19/Cleaned Data/fipandcleanedsd.RDS')

fipsampledsd <- data.table(readRDS('~/Dropbox/Spatial COVID 19/Cleaned Data/fipandcleanedsd.RDS'))

mitelection <- data.table(read.csv('~/Dropbox/Spatial COVID 19/MITElectionLAB.csv'))
#merge demographic data with bootstrapped social distancing data. This gives demographic info about the county
#and county compliance with social distancing efforts.




##########################################
# MERGING MIT ELECTION LAB TO SD DATASET #
#########################################
# SOME NOTES
  # MIT ELECTION LAB data has demographic info by County and can merge by FIPS code
  # Calculated partisan control in historical elections
    # See CountyPartyControlCalculations.do for more info


library(foreign)
library(haven)
# load Cleaned and Sampled Social Distancing Dataset
fipsampledsd <- data.table(readRDS('/Users/damonroberts/Dropbox/Spatial COVID 19/fipandcleanedsd.RDS'))
#load MITELECTIONLABS Data to get demographic info and party majority in each county
censusdat <- data.table(read_dta('/Users/damonroberts/Dropbox/Spatial COVID 19/MITELECTIONLABS.dta'))

#need to make sure that the FIPS code is numeric for both datasets
fipsampledsd <- fipsampledsd %>%
  mutate(fips = as.numeric(fips))
censusdat <- censusdat %>%
  mutate(fips = as.numeric(fips))

fulldata <- merge(x = fipsampledsd, y = censusdat, by = 'fips')

saveRDS(fulldata, '/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data/finaldataset.RDS')

#Ready for analysis!
