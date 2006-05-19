function [qTypes, array2Index] = analyzecycleseries(imagePath)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
global prpResize
global grdMask
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


% check if parameter set, otherwise refer to defaults
pdef = getProperties();
for i=1:length(pdef) 
    if eval(['isempty(',pdef(i).name,')'])
        for j=1:length(pdef(i).dft)
            sj = num2str(j);
            eStr = [pdef(i).name,'(',sj,') =', num2str(pdef(i).dft(j)),';'];
            eval(eStr);
    
        end
    end
end
% map enumerated props
 
[val, map]= getpropenumeration('prpContrast');
strPrpContrast = char(map(prpContrast == val));
[val, map]    = getpropenumeration('segMethod');
strSegMethod = char(map(segMethod == val));
[val, map] = getpropenumeration('qntBackgroundMethod');
strQntBackgroundMethod = char(map(qntBackgroundMethod == val));
[val, map] = getpropenumeration('qntOutlierMethod');
strQntOutlierMethod = char(map(qntOutlierMethod == val));

% initialize preprocessing object
oPrep = preProcess('nSmallDisk' , prpSmallDisk * grdSpotPitch, ...
                   'nLargeDisk' , prpLargeDisk * grdSpotPitch, ...
                   'nCircle'    , prpCircleDiameter * grdSpotPitch, ...
                   'nBlurr'     , prpCircleBlurr * grdSpotPitch, ...
                   'contrast'   , strPrpContrast);
               
% initialize array object
if isempty(grdMask)
    error('PamSoft_Grid property ''grdMask'' has not been set');
end
if isempty(grdXOffset);
    grdXOffset = zeros(size(grdMask));
end
if isempty(grdYOffset)
    grdYOffset = zeros(size(grdMask));
end

oArray = array  ('mask'         , grdMask, ...
                 'spotPitch'    , grdSpotPitch, ...
                 'spotSize'     , grdSpotSize * grdSpotPitch, ...
                 'rotation'     , grdRotation, ...
                 'xOffset'      , grdXOffset, ...
                 'yOffset'      , grdYOffset);
             
% initialize segmentation object
oS0 = segmentation( 'method'            , strSegMethod, ...
                    'spotPitch'         , grdSpotPitch, ...
                    'edgeSensitivity'   , segEdgeSensitivity, ...
                    'areaSize'          , segAreaSize);
                
% initialize quantification object
if isequal(strQntOutlierMethod, 'none')
    oOut = [];
else
    oOut= outlier( 'method', strQntOutlierMethod, ...
                        'measure', qntOutlierMeasure);
end

oQ0 = spotQuantification('backgroundMethod', strQntBackgroundMethod, ...
                         'saturationLimit',  qntSaturationLimit, ...
                         'oOutlier', oOut);
                     
% read in the images 
nRead = 0;


for i=1:length(imagePath)
    if ~isempty(imagePath(i))
        nRead = nRead + 1;
        I(:,:,nRead) = imread(imagePath{i});
    end
end
nImages = size(I,3);
% initialize some implementation settings
if grdUseImage == 0
    % use first
    settings.nGridImage = 1;
elseif grdUseImage == -1
    % use last
    settings.nGridImage = nImages;
elseif grdUseImage > 0 & grdUseImage <= nImages
    settings.gridImage = grdUseImage;
else
    error('PamSoft_Grid, invalid value for grdUseImage');
end
settings.seriesMode         = qntSeriesMode;
sqc.minDiameter             = sqcMinDiameter;
sqc.maxDiameter             = sqcMaxDiameter;
sqc.minFormFactor           = sqcMinFormFactor;
sqc.maxAspectRatio          = sqcMaxAspectRatio;
sqc.maxOffset               = sqcMaxPositionOffset;
settings.sqc = sqc;
settings.resize             = prpResize;


[stateQuantification, oArray] = gridCycleSeries(I, oPrep, oArray, oS0, oQ0, qntSpotID, settings);
for i=1:nImages
    [qTypes(:,:,i), array2Index] = makeQTypes(stateQuantification(:,:,i));
end



% permute qTypes from: DesignElement-QuantitationType-BioAssay 
% to : BioAssay-DesignElement-QuantitationType
qTypes = permute(qTypes, [3,1,2]);


%EOF