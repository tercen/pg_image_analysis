function [qFinal, oArray] = gridCycleSeriesCombineExposures(I, oP, oArray, oS0, oQ0,clID, T, settings)
% function [qFinal, oArray] = gridCycleSeries(gdata, I)
if settings.seriesMode == 0 
        [qFinal, oArray] = seriesFixed(I,oP, oArray, oS0, oQ0, clID, T, settings);
elseif settings.seriesMode == 1
        error('Adaptive gridding is not supported with multiple exposure time gridding');
end

% ------------------------------------------------------------------------
function [qFinal, oArray] = seriesFixed(I, oP, oArray, oS0, oQ0, clID, T, settings)
% gridding with segmentation fixed on gridImage
nImages = size(I,3);

iGrid = settings.nGridImage;
rSize = settings.resize;
sqc = settings.sqc;
% preprocessing and grid finding

% create the grid image 
satLimit = get(oQ0, 'saturationLimit');
oc = combineExposureTimes('combinationCriterium',satLimit);
Igrid = combineImages(oc, I(:,:,iGrid), T);
Igrid = I(:,:,end);


rsizFactor = rSize./size(Igrid);
oPP = rescale(oP, rsizFactor(1));
Igrid = getPrepImage(oPP, imresize(Igrid, rSize));

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
                       'ID', clID, ...
                       'arrayRow', get(oArray, 'row'), ...
                       'arrayCol', get(oArray, 'col'));
                   
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



        