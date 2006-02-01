function segmentSingle(imagePath, xGrid, yGrid, rotation)
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

% read in the required image
I = imread(char(imagePath));
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

 %segment                   
 oS = segment(oS0, I, xGrid, yGrid,rotation);
% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
qArray = setSet(oQ0, oS, oProps,qntSpotID);
qArray = check4EmptySpots(qArray);
qArray = replaceEmptySpots(qArray);
qArray = check4BadSpots(qArray, 'mindiameter', grdSpotPitch * sqcMinDiameter, ...
                              'maxdiameter', grdSpotPitch * sqcMaxDiameter, ...
                              'maxaspectRatio', sqcMaxAspectRatio, ...  
                              'minformFactor', sqcMinFormFactor, ...
                              'maxpositionDelta',grdSpotPitch * sqcMaxPositionOffset);
                              
stateQuantification = replaceBadSpots(qArray);
                   