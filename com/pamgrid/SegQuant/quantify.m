function quantify(I)
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

if isempty(seg_Result)
    error('The ''quantify'' method requires that a segmentation has been calculated using the ''segment'' method');
end



oS = segmentation(seg_Result);

% recalculate center coordinates from seg_Result.

[nRows, nCols] = size(seg_Result.spots);
[cLu{1:nRows, 1:nCols}] = deal(seg_Result.spots.cLu);
cLu = cell2mat(cLu); xLu = cLu(:, 1:2:end); yLu = cLu(:, 2:2:end);
cx = xLu + seg_Result.areaSize/2;
cy = yLu + seg_Result.areaSize/2;

if isempty(qBackgroundMethod);
    qBackgroundMethod = 'interleaved';
end
if isempty(qBackgroundDiameter)
    qBackgroundDiameter = 4;
end
if isempty(qOutlierMethod)
    qOutlierMethod  = 'none';
end

oQ = spotQuantification(oS, I, cx, cy, ...
                        'backgroundMethod', qBackgroundMethod, ...
                        'backgroundDiameter', qBackgroundDiameter, ...
                        'outlierMethod', qOutlierMethod);

q_Result = struct(oQ);
% EOF