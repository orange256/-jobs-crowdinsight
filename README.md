# -jobs-crowdinsight
for job task

There are 4 Rscripts:

1.myfunctions.R

    this Rscript contain self define functions.

2.Task_1_SVM.R

    [Goal]: emotions detect by Chinese text (without using any pre-train model, use training data only)
    
    [pre-processiing]: invalid value check(rate), chinese word segment, stopwords cleaning, prune vocab...
    
    [feature extraction]: Document-Term Matrix (DTM)
    
    [Model]: SVM, Random Forest (RF)
    
    [Accuracy]: RF (68.3%) is better than SVM (65.2%)
    
    [How to do better?]: We can do some feature selection (by importance, gain, TF-IDF....etc) to get higher accuracy.
                        (如果有興趣的話，這部分可以二面時詳談)
                   
                    
3.Task_2_recommendation_kmean.R
    
    [Goal]: construct a recommendation model (user-based)
    
    [discription]: 
        (1) only use 2 variable 'user', 'item' (without using datetime)
        (2) 90% training / 10% testing
         
    
    
    [feature extraction]: 
    
    [Model]: 
    
    [Accuracy]: 
    
    [How to do better?]: We can do some feature selection (by importance, gain, TF-IDF....etc) to get higher accuracy.
                        (如果有興趣的話，這部分可以二面時詳談)

    
    
    
4.Task_2_date_FeatureExtraction.R
      
