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
    
    [Discription]: 
        (1) only use 2 variable: 'user', 'item' (without using datetime)
        (2) 90% training / 10% testing
        (3) seperate user into 100 clusters , and find top-10 items in each cluster (make recommendation list)
        (4) In testing step, if item (which bought by user) is exist in recommendation list, then call TRUE, otherwise call FALSE.
        (5) Compute accuracy of testing data : N(TRUE) / (N(TRUE) + N(FALSE))
        (6) Show accuracy of different combination: (num of cluster, num of recomment items)
             
    [Model]: k-mean cluster analysis
    
    [Accuracy]: example : (num of cluster , num of recomment items) => Accuracy
       
            (10, 2)   => 0.0683132
            (10, 5)   => 0.1097803
            (10, 10)  => 0.1649182
            (10, 30)  => 0.2779613
            (10, 100) => 0.4685280
            
            (1000, 2)   => 0.2316207
            (1000, 5)   => 0.3694036
            (1000, 10)  => 0.459359
            (1000, 30)  => 0.5858665
            (1000, 100) => 0.7148934       
            
    [How to do better?]: 
        (1) add "datetime" related features
        (2) others algorithm...
    
   (如果有興趣的話，這部分可以二面時詳談)

    
4.Task_2_date_FeatureExtraction.R

    This Rscript show how to extract features from 'datetime'
        eg: hour, day, weekday... 
      
