function [qFinal, oArray] = gridCycleSeries(I, oP, oArray, oS0, oQ0,clID, settings)
% function [qFinal, oArray] = gridCycleSeries(gdata, I)
if settings.seriesMode == 0 
        [qFinal, oArray] = seriesFixed(I,oP, oArray, oS0, oQ0, clID, settings);
elseif settings.seriesMode == 1
        [qFinal, oArray] = seriesAdapt(I, oP, oArray, oS0, oQ0, clID, settings);
end

% ------------------------------------------------------------------------
function [qFinal, oArray] = seriesFixed(I, oP, oArray, oS0, oQ0, clID, settings)
% gridding with segmentation fixed on gridImage
nImages = size(I,3);

iGrid = settings.nGridImage;
rSize = settings.resize;
sqc = settings.sqc;
% preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(oP, rsizFactor(1));
Igrid = getPrepImage(oPP, imresize(I(:,:,iGrid), rSize));

spotPitch   = get(oArray, 'spotPitch');
spotSize    = get(oArray, 'spotSize');
oArray = set(oArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));


 [x,y,rotOut, oArray] = gridFind(oArray, Igrid);
% scale back to original image size, make sure the coordinates are within the image 
oArray = set(oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);
% perform segmentation

oS = segment(oS0, I(:,:, iGrid), x, y,rotOut);
% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
qArray = setSet(oQ0,   'oSegmentation', oS, ...
                            'oProperties', oProps, ...
                            'ID', clID);
qArray = check4EmptySpots(qArray);
qArray = replaceEmptySpots(qArray);
qArray = check4BadSpots(qArray, 'mindiameter', spotPitch * sqc.minDiameter, ...
                                'maxdiameter', spotPitch * sqc.maxDiameter, ...
                                'maxaspectRatio', sqc.maxAspectRatio, ...  
                                'minformFactor', sqc.minFormFactor, ...
                                'maxpositionDelta',spotPitch * sqc.maxOffset);
                              
qArray = replaceBadSpots(qArray);
% apply to all images from the series
for i=1:nImages
    qFinal(:,:,i) = quantify(qArray, I(:,:,i));
end
disp('');

%--------------------------------------------------------------------------
function [qFinal, oArray] = seriesAdapt(I, oP, oArray, oS0, oQ0, clID, settings)
% Gridding with fixed segmentation moving over the image
nImages = size(I,3);

iGrid = settings.nGridImage;
rSize = settings.resize;
sqc = settings.sqc;
% preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(oP, rsizFactor(1));
Igrid = getPrepImage(oPP, imresize(I(:,:,iGrid), rSize));

spotPitch   = get(oArray, 'spotPitch');
spotSize    = get(oArray, 'spotSize');
oArray = set(oArray, 'spotPitch', spotPitch .* rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));

[x,y,rotOut, oArray] = gridFind(oArray, Igrid);
% scale back to original image size, make sure the coordinate sare within the image 
x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

% perform segmentation
oS0 = set(oS0, 'spotPitch', spotPitch);
oS = segment(oS0, I(:,:, iGrid), x, y,rotOut);
% quality control
oProps = setPropertiesFromSegmentation(spotProperties, oS);
qArray = setSet(oQ0,   'oSegmentation', oS, ...
                            'oProperties', oProps, ...
                            'ID', clID);
qArray = check4EmptySpots(qArray);
qArray = replaceEmptySpots(qArray);
qArray = check4BadSpots(qArray, 'mindiameter', spotPitch * sqc.minDiameter, ...
                              'maxdiameter', spotPitch * sqc.maxDiameter, ...
                              'maxaspectRatio', sqc.maxAspectRatio, ...  
                              'minformFactor', sqc.minFormFactor, ...
                              'maxpositionDelta',spotPitch * sqc.maxOffset);
qArray = replaceBadSpots(qArray);
clSeg = get(qArray, 'oSegmentation');
principalSegmentation = [clSeg{:}]; 
principalSegmentation = reshape(principalSegmentation, size(qArray));
% the principal segmentation is the final segmentation including qc
% replacements
% that we'll use to fit on the shifting grid.
mask = get(oArray, 'mask');
iRef = find(mask);
res = getResult(qArray(iRef));
[xPos{1:length(res)}]  = deal(res.X_Position); xPos = cell2mat(xPos);
[yPos{1:length(res)}]  = deal(res.Y_Position); yPos = cell2mat(yPos);
mp0 = [mean(xPos), mean(yPos)];

for i=1:nImages
    % now find the grid on the individual images, 
    Igrid = getPrepImage(oPP, imresize(I(:,:,i), rSize));
    [x,y,rotOut, oArray] = gridFind(oArray, Igrid);
    x = x/rsizFactor(1);
    y = y/rsizFactor(2);
    x(x<1) = 1;
    y(y<1) = 1; 
    x(x>size(I,1)) = size(I,1);
    y(y>size(I,2)) = size(I,2);
    % resegment the refs only
    sRefs = segment(oS0, I(:,:,i), x(iRef), y(iRef), rotOut);
    pRefs = setPropertiesFromSegmentation(spotProperties, sRefs);
    % find the position midpoint
    qRefs = setSet(oQ0, 'oSegmentation', sRefs, 'oProperties', pRefs);
    res = getResult(qRefs);
    [clxPos{1:length(res)}]  = deal(res.X_Position); xPos = cell2mat(clxPos);
    [clyPos{1:length(res)}]  = deal(res.Y_Position); yPos = cell2mat(clyPos);
    mp = [mean(xPos), mean(yPos)];
    % shift the entire principal segmentation based on mp shift found
    coS = shift(principalSegmentation,mp - mp0);
    qFinal(:,:,i) = setSet(qArray, coS, [], []);
    qFinal(:,:,i) = quantify(qFinal(:,:,i), I(:,:,i));
end
% scale the array object back for next run
oArray = set(oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);

        