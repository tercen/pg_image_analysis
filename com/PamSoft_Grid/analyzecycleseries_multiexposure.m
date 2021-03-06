function qTypes = analyzecycleseries_multiexposure(imagePath, T, P)
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
global grdXPosition
global grdYPosition
global grdXOffset
global grdYOffset
global grdUseImage
global grdXFixedPosition
global grdYFixedPosition
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
global qntShowPamGridViewer
global stateQuantification

if ~iscell(imagePath)
    imagePath = cellstr(imagePath);
end

if length(T) ~= length(imagePath) | length(P) ~= length(imagePath) | length(P) ~= length(T)
    error('Input arguments ''P'', ''T'', and ''imagePath'' must be arrays of the same length')
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
if isempty(grdRow)
    error('PamSoft_Grid property ''grdRow'' has not been set');
end

if isempty(grdCol)
    error('PamSoft_Grid property ''grdCol'' has not been set');
end

if isempty(grdIsReference)
    error('PamSoft_Grid property ''grdIsReference'' has not been set');
end
if isempty(grdXOffset);
    grdXOffset = zeros(size(grdRow));
end
if isempty(grdYOffset)
    grdYOffset = zeros(size(grdCol));
end

oArray = array  ('row'          , grdRow, ...
                 'col'          , grdCol, ...
                 'isreference'  , grdIsReference, ...
                 'spotPitch'    , grdSpotPitch, ...
                 'spotSize'     , grdSpotSize * grdSpotPitch, ...
                 'rotation'     , grdRotation, ...
                 'xOffset'      , grdXOffset, ...
                 'yOffset'      , grdYOffset);
             
% initialize segmentation object
oS0 = segmentation( 'method'            , strSegMethod, ...
                    'spotPitch'         , grdSpotPitch, ...
                    'edgeSensitivity'   , segEdgeSensitivity, ...
                    'areaSize'          , segAreaSize, ...
                    'nFilterDisk'       , prpLargeDisk * grdSpotPitch);
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

% The grid images are the exposure time series images of first / last / requested cycle
[uP,pUbels, pLabels] = unique(P);
if grdUseImage == 0
    % use first
    settings.nGridImage = find(pLabels == 1);
elseif grdUseImage == -1
    % use last
    settings.nGridImage = find(pLabels == length(uP));
elseif grdUseImage > 0 & grdUseImage <= nImages
    settings.nGridImage = find(pLabels == grdUseImage);
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


[stateQuantification, oArray] = pgrCycleSeriesCombineExposures(I, oPrep, oArray, oS0, oQ0, qntSpotID, T(settings.nGridImage),settings);
for i=1:nImages
    qTypes(:,:,i) = makeQTypes(stateQuantification(:,:,i));
end



% permute qTypes from: DesignElement-QuantitationType-BioAssay 
% to : BioAssay-DesignElement-QuantitationType
qTypes = permute(qTypes, [3,1,2]);


%EOF