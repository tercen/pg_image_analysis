function segment(I, x,y, rotation)
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

if isempty(segAreaSize)
    error('Parameter ''segAreaSize'' has not been defined');
end

oS = segmentation('rotation', rotation, 'areaSize', segAreaSize);

%% input checking and parameter setting
% if parameters not set revert to dft
if isempty(segMethod)
    segMethod = get(oS, 'method');
else
    oS = set(oS, 'method', segMethod);
end

if isequal(segMethod, 'FilterThreshold') & isempty(segFilterDiskSize)
    error('When using the ''FilterThreshold'' segmentation method parameter ''segFilterDiskSize'' has to be defined');
else
    oS = set(oS, 'nFilterDisk', segFilterDiskSize);
end

if isempty(segDftSpotSize)
    segDftSpotSize = get(oS, 'dftSpotDiameter');
else
    oS = set(oS, 'dftSpotDiamater', segDftSpotSize);
end
if isempty(segPixFlexibility)
    segPixFlexibility = get(oS, 'pixFlexibility');
else
    oS = set(oS, 'pixFlexibility', segPixFlexibility);
end

qc = get(oS, 'classifier'); 
if isempty(segMinDiameter)
    segMinDiameter = qc.minDiamater;
else
    qc.minDiamater = segMinDiameter;
end
if isempty(segMaxDiameter)
    segMaxDiamater = qc.maxDiameter;
else
    qc.maxDiameter = segMaxDiameter;
end

if isempty(segMinThrEfficiency)
    segMinThrEfficiency = qc.minThrEff;
else
    qc.minThrEff = segMinThrEfficiency;
end

if isempty(segMaxAspectRatio)
    segMaxAspectRatio = qc.maxAspectRatio;
else
    qc.maxAspectRatio = segMaxAspectRatio;
end

if isempty(segMinFormFactor)
    segMinFormFactor = qc.minFormFactor;
else
    qc.minFormFactor = segMinFormFactor;
end
oS = set(oS,'classifier', qc);

%% Perform the segmentation
oS = segment(oS, I, x, y);
% store the result in the seg_Result structure
seg_Result = get(oS);
% EOF

