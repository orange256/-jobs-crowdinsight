# -jobs-crowdinsight
for job task

There are 3 Rscripts:

1.myfunctions.R

    this Rscript contain self define functions.

2.Task_1_SVM.R

    [Goal]: emotions detect by Chinese text (with out any pre-train model, only use training data)
    
    [pre-processiing]: invalid value check, chinese word segment, stopwords, prune vocab
    
    [feature extraction]: Document-Term Matrix (DTM)
    
    [Model]: SVM, Random Forest (RF)
    
    [Accuracy]: RF (68.3%) is better than SVM (65.2%)
    
    [Further work]: We can do some feature selection to get higher accuracy rate
                    (by importance, gain, TF-IDF....etc), 
                    
3.Task_2_recommendation.R
      
