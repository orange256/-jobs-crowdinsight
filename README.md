# -jobs-crowdinsight
for job task

There are 4 Rscripts:

1.myfunctions.R

    this Rscript contain self define functions.

2.Task_1_SVM.R

    [Goal]: emotions detect by Chinese text 
    
    [Discription]: 
        (1) only use training data (without using any emotion pre-train model)
        (2) find some invalid rate : "3" , ""
        (3) 5-fold cross validation
        (4) SVM accuracy : 65.2%
        (5) Random Forest accuracy : 68.3%
    
    [Pre-processiing]: remove invalid rate , chinese word segment, stopwords cleaning, prune vocab...
    
    [Feature extraction]: Document-Term Matrix (DTM)
    
    [Model]: SVM, Random Forest (RF)
    
    [Result]: RF (68.3%) is better than SVM (65.2%)
    
    [How to do better?]: 
        (1) Do some feature selection (by importance, gain, TF-IDF....etc) 
        (2) Use pre-train model 
        
                        (如果有興趣的話，這部分可以二面時詳談)
                   
                    
3.Task_2_recommendation_kmean.R
    
    [Goal]: construct a recommendation model (user-based)
    
    [discription]: 
        (1) only use 2 variable 'user', 'item' (without using datetime)
        (2) 90% training / 10% testing
        (3) use 100 cluster to demo, and find top 10 item in each cluster (recomment list)
        (4) use 
         
    
    
    [feature extraction]: 
    
    [Model]: kmean cluster analysis
    
    [Accuracy]: 
    
    [How to do better?]: 

    
    
    
4.Task_2_date_FeatureExtraction.R
      
