function qTypes = analyzecycleseries(imagePath)
global prpContrast
global prpLargeDisk
global prpSmallDisk
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
global grdXFixedPosition
global grdYFixedPosition
global grdSearchDiameter
global grdOptimizeSpotPitch
global grdOptimizeRefVsSub;
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
global qntOutlierMethod
global qntOutlierMeasure
global qntShowPamGridViewer
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
% [val, map]    = getpropenumeration('segMethod');
% strSegMethod = char(map(segMethod == val));
strSegMethod = 'Edge';
% [val, map] = getpropenumeration('qntBackgroundMethod');
% strQntBackgroundMethod = char(map(qntBackgroundMethod == val));
strQntBackgroundMethod = 'localCorner';
[val, map] = getpropenumeration('qntOutlierMethod');
strQntOutlierMethod = char(map(qntOutlierMethod == val));

% read in the images 
nRead = 0;
for i=1:length(imagePath)
    if ~isempty(imagePath(i))
        nRead = nRead + 1;
        I(:,:,nRead) = imread(imagePath{i});
    end
end
nImages = size(I,3);

% initialize preprocessing object
oPrep = preProcess('nSmallDisk' , prpSmallDisk * grdSpotPitch, ...
                   'nLargeDisk' , prpLargeDisk * grdSpotPitch, ...
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
if isempty(grdXFixedPosition)
    grdXFixedPosition = zeros(size(grdCol));
end
if isempty(grdYFixedPosition)
    grdYFixedPosition = zeros(size(grdCol));
end


if ~isempty(grdSearchDiameter)
    mp = size(I(:,:,1))/2;
    r = grdSpotPitch * grdSearchDiameter/2;
    [r,c] = circle(mp, r, round(2*pi*r));
    srchRoi = roipoly(I(:,:,1), c,r);    
else
    srchRoi = [];
end



oArray = array  ('row'              , grdRow, ...
                 'col'              , grdCol, ...
                 'isreference'      , grdIsReference, ...
                 'spotPitch'        , grdSpotPitch, ...
                 'spotSize'         , grdSpotSize * grdSpotPitch, ...
                 'rotation'         , grdRotation, ...
                 'xOffset'          , grdXOffset, ...
                 'yOffset'          , grdYOffset, ...
                 'xFixedPosition'   , grdXFixedPosition, ...
                 'yFixedPosition'   , grdYFixedPosition, ...
                 'roiSearch'        , srchRoi, ... 
                 'ID'               , qntSpotID);
             
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
                     




% initialize some implementation settings
if grdUseImage == 0
    % use first
    settings.nGridImage = 1;
    settings.nSegImage  = 1;
elseif grdUseImage == -1
    % use last
    settings.nGridImage = nImages;
    settings.nSegImage = nImages;
elseif grdUseImage == -2
    % grid on first, seg on last
    settings.nGridImage = 1;
    settings.nSegImage = nImages;
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
settings.optimizeSpotPitch  = grdOptimizeSpotPitch;
settings.optimizeRefVsSub   = grdOptimizeRefVsSub;

stateQuantification = pgrCycleSeriesTest(I, oPrep, oArray, oS0, oQ0, settings);
for i=1:nImages
  
    qTypes(:,:,i) = makeQTypes(stateQuantification(:,:,i));
end

% permute qTypes from: DesignElement-QuantitationType-BioAssay 
% to : BioAssay-DesignElement-QuantitationType
qTypes = permute(qTypes, [3,1,2]);

if qntShowPamGridViewer ~=0
    hViewer = showInteractive(stateQuantification, I, 1:nImages);
    set(hViewer, 'Name', 'PamGridViewer');
    if qntShowPamGridViewer == 1
        uiwait(hViewer);
    end
end

%EOF