function qShow(imagePath, xAx, strTitle)
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

if ~iscell(imagePath)
    imagePath = cellstr(imagePath);
end

n = 0;
for i=1:length(imagePath)
   if ~isempty(imagePath(i))
       n = n+1; 
       I(:,:,n) = imread(imagePath{i});
    end
end

if nargin == 1 || length(xAx) ~= length(imagePath)
    xAx = 1:length(imagePath);
end

if nargin < 3 | ~ischar(strTitle)
    strTitle = '';
end

hp = showInteractive(stateQuantification, I, xAx);
set(hp, 'name', strTitle);
