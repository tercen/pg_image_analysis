function [aNumeric, aHeader] = dataFrameOperator(folder)
global data
global outlierSpec

runFile = fullfile(folder, 'plsCube.mat');
save(runFile, 'data');
aNumeric = [];
aHeader = [];
eval(['!open "',folder,'"'])