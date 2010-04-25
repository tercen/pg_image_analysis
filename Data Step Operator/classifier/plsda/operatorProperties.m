function props = operatorProperties()
global MaxComponents
global AutoScale
global CrossValidationType
global NumberOfPermutations
global SaveClassifier
props = {   'MaxComponents', 10;
            'AutoScale', {'no', 'yes'};
            'CrossValidationType', {'LOOCV', '10-fold', '20-fold'}; 
            'NumberOfPermutations', 0;
            'SaveClassifier', {'no', 'yes'} };
return