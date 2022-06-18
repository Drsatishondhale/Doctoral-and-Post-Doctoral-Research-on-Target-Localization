
clear all
    close all
    clc
RSSI_Input= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
TargetX= [3,6,9,12,15,18,21,24,27,30];

%'linear' (default) | 'gaussian' | 'rbf' | 'polynomial' | function name

Mdl = fitrsvm(RSSI_Input',TargetX','KernelFunction','linear');
compactMdl = compact(Mdl)
CVMdl = crossval(Mdl)
RSS_new_vector1 = 4;         
SVMX = predict(Mdl,RSS_new_vector1)