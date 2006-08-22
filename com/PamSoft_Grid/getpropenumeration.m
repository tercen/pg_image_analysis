function [val, map] = getPropEnumeration(parName)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
global prpResize
global grdRow
global grdCol
global grdIsReference
global grdRotation
global grdSpotPitch
global grdSpotSize
global grdXOffset
global grdYOffset
global grdUseImage
global segMethod
global segEdgeSensitivity
global segAreaSize
global sqcMaxDiameter
global sqcMinDiameter
global sqcMinFormFactor
global sqcMaxAspectRatio
global sqcMaxPositionOffset
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntBackgroundMethod
global qntOutlierMethod
global qntOutlierMeasure
global stateQuantification

pdef = getProperties();
[pnames{1:length(pdef)}] = deal(pdef.name);
iMatch = strmatch(parName, pnames, 'exact');
if ~isempty(iMatch) && ~isempty(pdef(iMatch).enumVal)
    val = pdef(iMatch).enumVal;
    map = pdef(iMatch).enumMap;
else
    val = [];
    map = '';
end
 
        
