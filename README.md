# -jobs-crowdinsight
for job task

There are 3 Rscripts:

1.[myfunctions] 

    this Rscript contain self define functions.

2.[Task_1_SVM]

    Goal: emotions detect by Chinese text (with out any pre-train model, only use training data)
    
    pre-processiing: invalid value check, chinese word segment, stopwords, prune vocab
    
    feature: Document-Term Matrix (DTM)
    
    Model: SVM, Random Forest (RF)
    
    Accuracy: RF (68.3%) is better than SVM (65.2%)
      
