%%test
clear all
close all

global MaxComponents
global CrossValidationType
global AutoScale
global SaveClassifier
global NumberOfPermutations
global ShowGraphicalOutput
NumberOfPermutations = 0;
MaxComponents = 10;
CrossValidationType = 'resub';
AutoScale = 'no';
SaveClassifier = 'no';
ShowGraphicalOutput = 'yes';
%load cmlMarrow.mat
load cmlMarrow.mat

p = path;
path(path, '..')

cOut = dataFrameOperator(fCubeIn, metaData, pwd);
showResults(pwd);

path(p);