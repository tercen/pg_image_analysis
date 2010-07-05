function qTypes = analyzeimageseries(imagePath)
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
global sqcMaxPositionOffset
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntOutlierMethod
global qntOutlierMeasure
global qntShowPamGridViewer
global stateQuantification

if isempty(imagePath)
    return
end

if ischar(imagePath)
    imagePath = cellstr(imagePath);
end
if ~iscellstr(imagePath)
    error('Invalid input to analyzecycleseries: expects array of char or cell array of strings')
end

%% check if the properties are set, otherwise refer to defaults
 
% Check if properties are set, otherwise use dft values.
props = whos('global');
for i=1:length(props)
    t = props(i).size;
 
    if ~all(t)
        dftVal = getpropdefault(props(i).name);
        assignval(props(i).name, dftVal);      
    end
end

% construct a preProcessing object
[val, map]= getpropenumeration('prpContrast');
strPrpContrast = char(map(prpContrast == val));
oPrep = preProcess('nSmallDisk' , prpSmallDisk * grdSpotPitch, ...
                   'nLargeDisk' , prpLargeDisk * grdSpotPitch, ...
                   'contrast'   , strPrpContrast);
               
%construct an array object
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
    % we need an the size of an example image here
    sInfo = imfinfo(imagePath{1});
    bw = false(sInfo.Height, sInfo.Width);
    mp = size(bw)/2;
    r = grdSpotPitch * grdSearchDiameter/2;
    [r,c] = circle(mp, r, round(2*pi*r));
    srchRoi = roipoly(bw, c,r);    
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
             
             
% construct a segmentation object
strSegMethod = 'Edge';
oS0 = segmentation( 'method'            , strSegMethod, ...
                     'spotPitch'         , grdSpotPitch, ...
                     'edgeSensitivity'   , segEdgeSensitivity, ...
                     'nFilterDisk'       , prpSmallDisk * grdSpotPitch, ...
                     'areaSize'          , segAreaSize);

% construct a spotQuantification object
[val, map] = getpropenumeration('qntOutlierMethod');
strQntOutlierMethod = char(map(qntOutlierMethod == val));

if isequal(strQntOutlierMethod, 'none')
    oOut = [];
else
    oOut= outlier( 'method', strQntOutlierMethod, ...
                        'measure', qntOutlierMeasure);
end

strQntBackgroundMethod = 'localCorner';
oQ0 = spotQuantification('backgroundMethod', strQntBackgroundMethod, ...
                          'saturationLimit',  qntSaturationLimit, ...
                          'oOutlier', oOut);


% construct a spotQualityAssessment object                      
sqc = spotQualityAssessment(    'maxDiameter'       , sqcMaxDiameter, ...
                                'minDiameter'       , sqcMinDiameter, ...
                                'maxOffset'         , sqcMaxPositionOffset );
                            
% finaly construct a pamgrid object 

[val, map]= getpropenumeration('grdOptimizeSpotPitch');
strOpPitch = char(map(grdOptimizeSpotPitch == val));

[val, map]= getpropenumeration('grdOptimizeRefVsSub');
strOpRefVsSub = char(map(grdOptimizeRefVsSub == val));

[val, map]= getpropenumeration('qntSeriesMode');
strSeriesMode = char(map(qntSeriesMode == val));

[val, map]= getpropenumeration('grdUseImage');
strUseImage = char(map(grdUseImage == val));


pgr = pamgrid(  'oPreProcessing',   oPrep, ...
                'oArray',   oArray, ...
                'oSegmentation', oS0, ...
                'oSpotQuantification', oQ0, ...
                'oSpotQualityAssessment', sqc, ...
                'gridImageSize', prpResize, ...
                'optimizeSpotPitch', strOpPitch, ...
                'optimizeRefVsSub', strOpRefVsSub, ...
                'seriesMode', strSeriesMode, ...
                'useImage', strUseImage);
            

[stateQuantification, I, exp, cycles] = analyzeImages(pgr, imagePath);

%stateQuantification = analyzeImages(pgr, imagePath);
for i=1:size(stateQuantification,2)
     [qn, qTypes(:,:, i)] = parseResults(stateQuantification(:,i));
end

%permute qTypes from: Spot-QuantitationType-Array 
% % to : Array-Spot-QuantitationType
qTypes = permute(qTypes, [3,1,2]);

if qntShowPamGridViewer ~=0 
    if length(unique(exp))> 1
        x = exp;
    else
        x = cycles;
    end

    hViewer = showInteractive(stateQuantification, I, x);
    set(hViewer, 'Name', 'PamGridViewer');
    if qntShowPamGridViewer == 1
        uiwait(hViewer);
    end
end


%EOF

function assignval(varName, value)
assignin('caller', varName, value);


