function [medianSignal, medianBackground, medianSigmBg] = getmedian
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
[clMedianSignal{1:nRows, 1:nCols}] = deal(q_Result.medianSignal);
[clMedianBackground{1:nRows, 1:nCols}] = deal(q_Result.medianBackground);
medianSignal = cell2mat(clMedianSignal);
medianBackground = cell2mat(clMedianBackground);
medianSigmBg = medianSignal - medianBackground;


    