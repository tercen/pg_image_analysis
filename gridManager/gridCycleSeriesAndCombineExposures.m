function gdata = gridCycleSeriesAndCombineExposures(gdata, I, pumpCycle, expTime)
% get some general settings from the gui
gdata.oP = set(gdata.oP, 'contrast', gdata.spotWeight);

switch gdata.segmentationMethod
    case 'Edge'
        nFilt = 0;
    case 'Threshold'
        nFilt = gdata.iniPars.ppLargeDisk;
end

gdata.oS = set(gdata.oS,    'method', gdata.segmentationMethod, ...
                            'nFilterDisk', nFilt);                      
switch gdata.seriesMode
    case 'fixed'
        gdata = seriesFixed(gdata,I, pumpCycle, expTime);
    case 'adapt'
        error('Adaptive gridding has (yet) not been implemented for the ''combine exposures'' option');
        
        %gdata = seriesAdapt(gdata,I, pumpCycle, Exposures);
end

function gdata = seriesFixed(gdata, I, p, exp)
% make sure everything is sorted with ascending cycle
[p, iSort] = sort(p);
exp = exp(iSort);
I = I(:,:,iSort);

[up, m, pLabels] = unique(p);
% set the grid Image
if isequal(gdata.gridMode, 'kinLast')
    iGrid = length(up);
elseif isequal(gdata.gridMode, 'kinFirst')
    iGrid = 1;
end

% create the grid image
satLimit = get(gdata.oQ, 'saturationLimit');
oc = combineExposureTimes('combinationCriterium',satLimit);
Ic = combineImages(oc, I(:,:,iGrid == pLabels), exp(iGrid == pLabels));

nImages = size(I,3);
rSize = [gdata.iniPars.xResize, gdata.iniPars.yResize];

% preprocessing and grid finding
rsizFactor = rSize./size(Ic);
oPP = rescale(gdata.oP, rsizFactor(1));

Igrid = getPrepImage(oPP, imresize(Ic, rSize));

spotPitch   = get(gdata.oArray, 'spotPitch');
spotSize    = get(gdata.oArray, 'spotSize');
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));

[x,y,rotOut, gdata.oArray] = gridFind(gdata.oArray, Igrid);
% scale back to original image size, make sure the coordinates are within the image 
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

% perform segmentation
oS = segment(gdata.oS, Ic, x, y,rotOut);

% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
qArray = setSet(gdata.oQ,   'oSegmentation', oS, ...
                            'oProperties', oProps, ...
                             'ID', gdata.clID);

qArray = check4EmptySpots(qArray);
qArray = replaceEmptySpots(qArray);
qArray = check4BadSpots(qArray, 'mindiameter', spotPitch * gdata.iniPars.minDiameter, ...
                              'maxdiameter', spotPitch * gdata.iniPars.maxDiameter, ...
                              'maxaspectRatio', gdata.iniPars.maxAspectRatio, ...  
                              'minformFactor', gdata.iniPars.minFormFactor, ...
                              'maxpositionDelta',spotPitch * gdata.iniPars.maxOffset);
                              
qArray = replaceBadSpots(qArray);

% apply to all images from the series
for i=1:nImages
    qImage(:,:,i) = quantify(qArray, I(:,:,i));
end

% now combine exposures for each cycle serie
[uPump, dummy, pumpLabels] = unique(p);
for i=1:length(uPump)
    qCombined(:,:,i) = combineExpTimeQuantification(qImage(:,:,i == pumpLabels), exp(i == pumpLabels));
end
gdata.qImage = qCombined;
% EOF

    
        
    

