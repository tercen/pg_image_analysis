function props = operatorProperties()
global data
global MaxComponents
global AutoScale
global BalanceBags
global CrossValidation
global Optimization
global Permutations
global SaveClassifier

props = {   'MaxComponents', 10, {'The maximal number of PLS components to use'}; ...
            'AutoScale', {'No', 'Yes'}, {'Autoscale Spot values?'}; ...
            'BalanceBags', 0, {'Number of balance bags to use for unbalanced data'}; ...
            'CrossValidation',{'LOOCV', '10-fold', '20-fold', 'none'}, {'Cross validation type'}; ...
            'Optimization', {'auto', 'LOOCV', '10-fold', '20-fold','none'}, {'Cross validation type for model optimization'}; ...
            'Permutations', 0, {'Number of label permutations to run'}; ...
            'SaveClassifier', {'No', 'Yes'}, {'Save the classifier to disk?'};
        };
     
            