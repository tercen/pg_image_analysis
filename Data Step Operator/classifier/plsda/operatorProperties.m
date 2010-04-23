function props = operatorProperties()
global MaxComponents
global CrossValidationType
global AutoScale
global SaveClassifier
props = {   'MaxComponents', 10;
            'CrossValidationType', {'LOOCV', '10-fold', '20-fold'}; 
            'AutoScale', {'no', 'yes'};
            'SaveClassifier', {'no', 'yes'} };
return