# data: read, clean ..... etc
library(data.table)
library(stringr)
library(magrittr)
library(dplyr)
library(tibble)
library(tidyr)
library(readr)
library(tm)

# text mining
library(jiebaR)
library(text2vec)

# Machine learning
library(e1071)
library(randomForest)

#self-define functions
source('myfunctions.R')

# mac
file_path <- "/Users/bee/Google Drive/R/Projects/[job]Crowdinsight/"
# windows
file_path <- "D:/Google Drive/R/Projects/[job]Crowdinsight/"

# [0] Load data ---------------------------------------------------------------------------------------

cat("Read data")
# read training data
training_data_dump <- tibble(text = read_lines(paste0(file_path,"data/Ch_trainfile_Sentiment_3000.txt"),skip = 1))
training_data <- training_data_dump %>%
  separate(text, into = c("rate", "txt"), sep = " ")
training_data <- cbind.data.frame(ID=1:3000, training_data)

# check: is invalid rate exist?
training_data$rate <- as.factor(training_data$rate)
table(training_data$rate)

# remove invalid rate : '' , '3'
training_data <- training_data[training_data$rate %in% c("-2", "-1", "0", "1", "2"), ]
training_data$rate <- droplevels(training_data$rate)
table(training_data$rate)


# [1] use 'jiebaR' to do word segment ---------------------------------------------------
training_words <- get_word_segment(training_data$txt)


# [2] use 'text2vec' to compute unique words --------------------------------------------
training_token <- itoken(training_words) # iterator

# remove useless words  
stop_words <- c(LETTERS,letters,0:10,tm::stopwords()) %>% unique()

a.vocab <- create_vocabulary(training_token,stopwords = stop_words)

#remove very common and uncommon words
prune_vocab <- prune_vocabulary(a.vocab,
                                doc_proportion_max = 0.3, 
                                doc_proportion_min = 0.001,
                                term_count_min = 3)

# [3] computing DTM (document term matrix)-----------------------------------------------

# vectorization of words
a.vectorizer <- vocab_vectorizer(prune_vocab,
                                 grow_dtm = TRUE,
                                 skip_grams_window = 5)

# get dtm 
training_DTM <- create_dtm(training_token, a.vectorizer, type = 'dgTMatrix')
full_training_DTM <- cbind.data.frame(V0 = training_data$rate,  as.matrix(training_DTM)) 

# [4] build SVM model -----------------------------------------------------

#SVM
SVM_model <- svm(V0 ~ .,
                 data = full_training_DTM, 
                 type = "C-classification", 
                 #kernel = "linear",
                 kernel = "radial",
                 cross = 5)

summary(SVM_model)

# linear
# Total Accuracy: 65.20282 
# Single Accuracies: 67.61745 65.32663 65.9396 65.49414 61.64154 

# radial
# Total Accuracy: 65.67214 
# Single Accuracies: 64.09396 63.14908 66.27517 67.67169 67.16918 


# [5] random Forest -----------------------------------------------------
library(randomForest)
set.seed(5566)
RF.model <- randomForest(x = as.matrix(training_DTM),
                         y = training_data$rate,
                         importance = TRUE,
                         ntree = 200,
                         do.trace = 10)
RF.model

# OOB estimate of  error rate: 31.68%  
# Accuracy = 68.32%, which is better than SVM model

# Confusion matrix:
#      -1 -2    0   1   2   class.error
#    ---------------------------------
# -1 | 80  0   67  35  19   0.6019900
# -2 |  2  0   25   5   6   1.0000000
# 0  | 20  0 1318 139 109   0.1689786
# 1  |  8  0  168 304  92   0.4685315
# 2  | 11  4  163  72 336   0.4266212


# which features are importance?
importance <- importance(RF.model) %>% as.data.frame()
  
# top 30 word of rate '2'
Good_top30_words <- importance %>% mutate(index=1:nrow(importance)) %>% arrange(desc(`2`)) %>% head(., 30)
row.names(importance)[Good_top30_words$index]

# top 30 word of rate '-2'
Bad_top30_words  <- importance %>% mutate(index=1:nrow(importance)) %>% arrange(desc(`-2`)) %>% head(., 30)
row.names(importance)[Bad_top30_words$index]


