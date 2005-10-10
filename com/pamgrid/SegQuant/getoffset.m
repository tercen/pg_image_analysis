function [xOffset, yOffset] = getoffset
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
for i=1:nRows
    for j=1:nCols
        sHok = size(q_Result(i,j).binSpot);
        cOffset = q_Result(i,j).Centroid - sHok/2;
        xOffset(i,j) = cOffset(1);
        yOffset(i,j) = cOffset(2);
    end
end
% EOF
        