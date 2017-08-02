library(data.table)
library(stringr)
library(magrittr)
library(dplyr)
library(tidyr)
library(readr)
library(reshape2)
library(Matrix)

#self-define functions
source('myfunctions.R')

# mac
file_path <- "/Users/bee/Google Drive/R/Projects/[job]Crowdinsight/"
# windows
file_path <- "D:/Google Drive/R/Projects/[job]Crowdinsight/"

# [0] data pre-processing -------------------------------------------------------------------

cat("Read data")
# read training_text
data_raw <- read.csv(paste0(file_path,"data/rs.csv"))

# # 90% to train
# train_index <- ceiling(0.9*nrow(data_raw)) %>% sample(1:nrow(data_raw), .)
# dt_train <- data_raw[ train_index, ]
# dt_test  <- data_raw[-train_index, ]


# format 
data_raw$user <- data_raw$user %>% as.factor() # 2000 user
data_raw$item <- data_raw$item %>% as.factor() # 1000 item

# feature extraction : 'month' & 'hour'
data_raw$datetime <- data_raw$datetime %>% as.character() 
data_raw$month <- data_raw$datetime %>% substr(., start= 6, stop= 7) %>% as.integer() 
data_raw$day   <- data_raw$datetime %>% substr(., start= 9, stop=10) %>% as.integer() 
data_raw$hour  <- data_raw$datetime %>% substr(., start=12, stop=13) %>% as.integer()

# see distribution of 'month' & 'hour'
table(data_raw$month) %>% barplot()
table(data_raw$day) %>% barplot()
table(data_raw$hour)  %>% barplot()

# feature extraction : 'time_section'
data_raw <- data_raw %>% mutate(time_section = ifelse(hour>=5 & hour<=10, "morning",
                                               ifelse(hour>=11 & hour<=14, "noon",
                                               ifelse(hour>=15 & hour<=17, "afternoon",
                                               ifelse(hour>=18 & hour<=23, "night", "daybreak")))))
table(data_raw$time_section) %>% barplot()

# change format of datetime
data_raw$datetime <- data_raw$datetime %>% as.Date(., format = "%Y-%m-%d %H:%M:%S")

# feature extraction : 'weekday'
Sys.setlocale("LC_TIME", "en_US")
data_raw$weekday <- data_raw$datetime %>% weekdays()
table(data_raw$weekday) %>% barplot()

# aggregate data : transfer to 'User-Item Matrix'
ratingDF <- dcast(data_raw, user ~ item, value.var = "qty")

dateDF <- dcast(data_raw, user ~ month) %>%
  merge(.,dcast(data_raw, user ~ day), by = 'user' ) %>%
  merge(.,dcast(data_raw, user ~ hour), by = 'user' ) %>%
  merge(.,dcast(data_raw, user ~ time_section), by = 'user' ) %>%
  merge(.,dcast(data_raw, user ~ weekday), by = 'user' ) 
  
# change column's name
names(dateDF)[2:13]  <- month.abb
names(dateDF)[14:44] <- paste0("D",1:31)
names(dateDF)[45:65] <- paste0("H",c(0:1, 5:23))

# merge data: full data
data_full <- merge(dateDF, ratingDF)
