%%test
clear all
close all

global MaxComponents
global CrossValidationType
global AutoScale
global SaveClassifier
global NumberOfPermutations
global ShowGraphicalOutput
NumberOfPermutations = 5;
MaxComponents = 10;
CrossValidationType = 'LOOCV';
AutoScale = 'no';
SaveClassifier = 'no';
ShowGraphicalOutput = 'yes';
load cmlMarrow.mat
%load cml_multiclass.mat

p = path;
path(path, '..')

cOut = dataFrameOperator(fCubeIn, metaData, pwd);
showResults(pwd);

path(p);