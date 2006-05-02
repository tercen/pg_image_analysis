function gdata = gridCycleSeries(gdata, I)
% function gdata = gridCycleSeroes(gdata, I)
% I , matrix of images, gdata, data structure coming from the ggridManager
% gui.

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
        gdata = seriesFixed(gdata,I);
    case 'adapt'
        gdata = seriesAdapt(gdata,I);
end
% ------------------------------------------------------------------------
function gdata = seriesFixed(gdata,I)
% gridding with segmentation fixed on gridImage
nImages = size(I,3);
rSize = [gdata.iniPars.xResize, gdata.iniPars.yResize];
% set the grid Image
if isequal(gdata.gridMode, 'kinLast')
    iGrid = nImages;
elseif isequal(gdata.gridMode, 'kinFirst')
    iGrid = 1;
end
% preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(gdata.oP, rsizFactor(1));

%oPP = set(oPP, 'contrast', 'co-equalize');

Igrid = getPrepImage(oPP, imresize(I(:,:,iGrid), rSize));

spotPitch   = get(gdata.oArray, 'spotPitch');
spotSize    = get(gdata.oArray, 'spotSize');
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));

[x,y,rotOut, gdata.oArray] = gridFind(gdata.oArray, Igrid);
% scale back to original image size, make sure the coordinate sare within the image 
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);
% perform segmentation

oS = segment(gdata.oS, I(:,:, iGrid), x, y,rotOut);
% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
qArray = setSet(gdata.oQ, oS, oProps, gdata.clID);
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
gdata.qImage = qImage;

%--------------------------------------------------------------------------

function gdata = seriesAdapt(gdata, I)
% Gridding with fixed segmentation moving over the image
nImages = size(I,3);
rSize = [gdata.iniPars.xResize, gdata.iniPars.yResize];
% set the grid Image
if isequal(gdata.gridMode, 'kinLast')
    iGrid = nImages;
elseif isequal(gdata.gridMode, 'kinFirst')
    iGrid = 1;
end
% preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(gdata.oP, rsizFactor(1));

Igrid = getPrepImage(oPP, imresize(I(:,:,iGrid), rSize));

spotPitch   = get(gdata.oArray, 'spotPitch');
spotSize    = get(gdata.oArray, 'spotSize');
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));

[x,y,rotOut, gdata.oArray] = gridFind(gdata.oArray, Igrid);
% scale back to original image size, make sure the coordinate sare within the image 

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

% perform segmentation
S0 = set(gdata.oS, 'spotPitch', spotPitch);
oS = segment(S0, I(:,:, iGrid), x, y,rotOut);
% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
% find the mean grid position based on the final position of the refs:

qArray = setSet(gdata.oQ, oS, oProps, gdata.clID);
qArray = check4EmptySpots(qArray);
qArray = replaceEmptySpots(qArray);
qArray = check4BadSpots(qArray, 'mindiameter', spotPitch * gdata.iniPars.minDiameter, ...
                              'maxdiameter', spotPitch * gdata.iniPars.maxDiameter, ...
                              'maxaspectRatio', gdata.iniPars.maxAspectRatio, ...  
                              'minformFactor', gdata.iniPars.minFormFactor, ...
                              'maxpositionDelta',spotPitch * gdata.iniPars.maxOffset);
                              
qArray = replaceBadSpots(qArray);
clSeg = get(qArray, 'oSegmentation');
principalSegmentation = [clSeg{:}]; 
principalSegmentation = reshape(principalSegmentation, size(qArray));
% the principal segmentation is the final segmentation including qc
% replacements
% that we'll use to fit on the shifting grid.
oArray = gdata.oArray;
mask = get(oArray, 'mask');
iRef = find(mask);
res = getResult(qArray(iRef));
[xPos{1:length(res)}]  = deal(res.X_Position); xPos = cell2mat(xPos);
[yPos{1:length(res)}]  = deal(res.Y_Position); yPos = cell2mat(yPos);
mp0 = [mean(xPos), mean(yPos)];

for i=1:nImages
    % now find the grid on the individual images, 
    Igrid = getPrepImage(oPP, imresize(I(:,:,i), rSize));
    [x,y,rotOut, oArray] = gridFind(gdata.oArray, Igrid);
    
    x = x/rsizFactor(1);
    y = y/rsizFactor(2);
    x(x<1) = 1;
    y(y<1) = 1; 
    x(x>size(I,1)) = size(I,1);
    y(y>size(I,2)) = size(I,2);
   
    % resegment the refs only
    sRefs = segment(S0, I(:,:,i), x(iRef), y(iRef), rotOut);
    pRefs = setPropertiesFromSegmentation(spotProperties, sRefs);
    
    % find the position midpoint
    qRefs = setSet(gdata.oQ, sRefs, pRefs, []);
    res = getResult(qRefs);
    [clxPos{1:length(res)}]  = deal(res.X_Position); xPos = cell2mat(clxPos);
    [clyPos{1:length(res)}]  = deal(res.Y_Position); yPos = cell2mat(clyPos);
    mp = [mean(xPos), mean(yPos)];
    % shift the entire principal segmentation based on mp shift found
    coS = shift(principalSegmentation,mp - mp0);
    qImage(:,:,i) = setSet(qArray, coS, [], []);
    qImage(:,:,i) = quantify(qImage(:,:,i), I(:,:,i));
end
gdata.qImage = qImage;
% scale the array object back for next run
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);

        