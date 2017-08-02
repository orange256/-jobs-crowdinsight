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

# format 
data_raw$user <- data_raw$user %>% as.factor() # 2000 user
data_raw$item <- data_raw$item %>% as.factor() # 1000 item

# 90% to train
set.seed(5566)
train_index <- ceiling(0.9*nrow(data_raw)) %>% sample(1:nrow(data_raw), .)
dt_train <- data_raw[ train_index, ]
dt_test  <- data_raw[-train_index, ]


# aggregate data : transfer to 'User-Item Matrix'
ratingDF <- dcast(dt_train, user ~ item, value.var = "qty")


# [1] K-Means Cluster: DEMO ----------------------------------

# Demo: use 100 clusters, and recomment 5 item list 
cluster_num <- 100
recomment_num <- 5

# cluster solution
fit <- kmeans(ratingDF, cluster_num) 

# get cluster sum 
cluster_sum_table <- aggregate(ratingDF[ ,-1], by=list(fit$cluster), FUN=sum)


recomment_list <- sapply(1:nrow(cluster_sum_table), function(i){
  sort(cluster_sum_table[i,-1], decreasing = T) %>% names() %>% head(recomment_num) 
}) %>% t()

# append cluster assignment
new_ratingDF <- data.frame(fit$cluster, ratingDF)
new_ratingDF$fit.cluster <- new_ratingDF$fit.cluster %>% as.factor()
#table(new_ratingDF$fit.cluster)

# [2] testing data ----------------------------------------------------------------

# get recomment result
recomment_matrix <- sapply(1:nrow(dt_test) , function(k) {get_recomment(dt_test$user[k], new_ratingDF, recomment_list)}) %>% t() %>% as.data.frame()

# combine data
dt_test_result <- cbind.data.frame(dt_test[ ,c(2:3)], recomment_matrix) %>% as.matrix()

# get result
myresult <- sapply(1:nrow(dt_test_result), function(j) {is_recomment_corret(dt_test_result[j,2], dt_test_result[j, 3:(2+recomment_num)])})
dt_test_result <- dt_test_result %>% as.data.frame() %>% mutate(result = myresult)

# compute performance
get_accuracy(dt_test_result$result)

# [3] which para setting is better? ------------------------------------------------

# see other parameter combinations
# cluster_num : number of cluster
# recomment_num : number of recommendation item

set.seed(12345678)

get_combination_performance(cluster_num = 10, recomment_num = 2)   # 0.0683132 (Accuracy)
get_combination_performance(cluster_num = 10, recomment_num = 5)   # 0.1097803
get_combination_performance(cluster_num = 10, recomment_num = 10)  # 0.1649182
get_combination_performance(cluster_num = 10, recomment_num = 30)  # 0.2779613
get_combination_performance(cluster_num = 10, recomment_num = 100) # 0.468528

get_combination_performance(cluster_num = 100, recomment_num = 2)   # 0.08966628
get_combination_performance(cluster_num = 100, recomment_num = 5)   # 0.1596316
get_combination_performance(cluster_num = 100, recomment_num = 10)  # 0.2349661
get_combination_performance(cluster_num = 100, recomment_num = 30)  # 0.392037
get_combination_performance(cluster_num = 100, recomment_num = 100) # 0.5868991

get_combination_performance(cluster_num = 300, recomment_num = 2)   # 0.1382785
get_combination_performance(cluster_num = 300, recomment_num = 5)   # 0.2400876
get_combination_performance(cluster_num = 300, recomment_num = 10)  # 0.3354948
get_combination_performance(cluster_num = 300, recomment_num = 30)  # 0.4910788
get_combination_performance(cluster_num = 300, recomment_num = 100) # 0.650793

get_combination_performance(cluster_num = 1000, recomment_num = 2)   # 0.2316207
get_combination_performance(cluster_num = 1000, recomment_num = 5)   # 0.3694036
get_combination_performance(cluster_num = 1000, recomment_num = 10)  # 0.459359
get_combination_performance(cluster_num = 1000, recomment_num = 30)  # 0.5858665
get_combination_performance(cluster_num = 1000, recomment_num = 100) # 0.7148934

get_combination_performance(cluster_num = 1500, recomment_num = 5)   # 0.4413927
get_combination_performance(cluster_num = 1999, recomment_num = 5)   # 0.4530811
