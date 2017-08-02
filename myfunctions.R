
# This function can help you to do word segment
# data : a list of articles
library(jiebaR)
get_word_segment <- function(data){
  cutter = worker(bylines = T)
  
  # segmentation
  article_words = lapply(data, function(x)  cutter <= x)
  
  # adjust to the format of text2vec
  article_words = lapply(article_words, '[[', 1)
  
  return(article_words)
}


# function: give 'user_ID' & 'new_ratingDF' to get recommendation list 
get_recomment <- function(user_ID, new_ratingDF, recomment_list){
  row_index <- which(new_ratingDF$user %in% user_ID)
  user_group <- new_ratingDF$fit.cluster[row_index]
  recommentdation <- recomment_list[user_group, ]
  return(recommentdation)
}


# function: return is recomment corret?
is_recomment_corret <- function(item, recomment){
  tmp <- item %>% as.character()
  tmp2 <- recomment %>% as.character()
  return(isTRUE(tmp %in% tmp2)
  )}


# function: return accuracy
get_accuracy <- function(result){
  tmp <- table(result) %>% as.vector()
  Accuracy <- tmp[2] /(tmp[1] + tmp[2])
  return(Accuracy)
}


# function: find best number of cluster & recomment list
get_combination_performance <- function(cluster_num, recomment_num){

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
  
  # get recomment result
  recomment_matrix <- sapply(1:nrow(dt_test) , function(k) {get_recomment(dt_test$user[k], new_ratingDF, recomment_list)}) %>% t() %>% as.data.frame()
  
  # combine data
  dt_test_result <- cbind.data.frame(dt_test[ ,c(2:3)], recomment_matrix) %>% as.matrix()
  
  # get result
  myresult <- sapply(1:nrow(dt_test_result), function(j) {is_recomment_corret(dt_test_result[j,2], dt_test_result[j, 3:(2+recomment_num)])})
  dt_test_result <- dt_test_result %>% as.data.frame() %>% mutate(result = myresult)
  
  # compute performance
  acc <- get_accuracy(dt_test_result$result) 
  return(acc)
  
}
