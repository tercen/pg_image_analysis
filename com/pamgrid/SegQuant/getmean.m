function [meanSignal, meanBackground, meanSigmBg] = getmean
global segAreaSize
global segFilterDiskSize
global segDftSpotSize
global segPixFlexibility
global segMinDiameter
global segMaxDiameter
global segMinThrEfficiency
global segMaxAspectRatio
global segMinFormFactor
global seg_Result
global segMethod
global segAreaSize
global segFilterDiskSize
global segDftSpotSize
global segPixFlexibility
global segMinDiameter
global segMaxDiameter
global segMinThrEfficiency
global segMaxAspectRatio
global segMinFormFactor
global seg_Result
global qBackgroundMethod;
global qBackgroundDiameter;
global qOutlierMethod;
global q_Result;

if isempty(q_Result)
    error('No quantification available');
end
[nRows, nCols] = size(q_Result);
[clSignal{1:nRows, 1:nCols}] = deal(q_Result.meanSignal);
[clBackground{1:nRows, 1:nCols}] = deal(q_Result.meanBackground);
meanSignal = cell2mat(clSignal);
meanBackground = cell2mat(clBackground);
meanSigmBg = meanSignal - meanBackground;


    