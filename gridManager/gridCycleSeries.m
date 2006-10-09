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
% here are some hardcoded settings:
maxSubIter = 2; % Max iterations for subs vs refs refinement 
maxRefSubOffset = 0.15; % Max offset criterium between refs and subs.

% gridding with segmentation fixed on gridImage
nImages = size(I,3);
rSize = [gdata.iniPars.xResize, gdata.iniPars.yResize];
% set the grid Image
if isequal(gdata.gridMode, 'kinLast')
    iGrid = nImages;
elseif isequal(gdata.gridMode, 'kinFirst')
    iGrid = 1;
end
% redusce the numver of pixels for efficiency (resize), preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(gdata.oP, rsizFactor(1));
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

% SEGMENTATION
S0 = set(gdata.oS, 'spotPitch', spotPitch);

% first segment the references, refine te spot pitch, allow for another pass
% to segment references that were not segmented correctly on the first pass
% based on refined settings
isRef = get(gdata.oArray, 'isreference');

% pre-allocate the array of segmentation objects:
% initalize some variables

xRef = x(isRef);
yRef = y(isRef);
oS = repmat(S0, size(x(isRef)));
bSegment = true(size(oS));

arrayRow = get(gdata.oArray, 'row');
arrayCol = get(gdata.oArray, 'col');
xOff = get(gdata.oArray, 'xOffset');
yOff = get(gdata.oArray, 'yOffset');
ID = get(gdata.oArray, 'ID');

array2fit = array(  'row', arrayRow(isRef), ...
    'col', arrayCol(isRef), ...
    'isreference', isRef(isRef), ...
    'xOffset', xOff(isRef), ...
    'yOffset', yOff(isRef), ...
    'spotPitch', spotPitch, ...
    'rotation', rotOut);

q = setSet(gdata.oQ, ...
    'ID', ID(isRef), ...
    'arrayRow', arrayRow(isRef), ...
    'arrayCol', arrayCol(isRef));

[qRefs, refSpotPitch, mpRefs]  = segmentAndRefine(I(:,:,iGrid), S0, array2fit, q, xRef, yRef, gdata.iniPars);

% Below the final spotQuantification object array, combination of qRef and
% possibly qSub
qAll = repmat(spotQuantification, size(arrayRow));
qAll(isRef) = qRefs; %so far, so good

% if any, segment and quantify the substrates (non refs), allow for another
% pass if the offset between resf and sub is to large

if any(~isRef)
    arrayRefined = array(...
        'row', arrayRow(~isRef), ...
        'col', arrayCol(~isRef), ...
        'isreference', isRef(~isRef), ...
        'xOffset', xOff(~isRef), ...
        'yOffset', yOff(~isRef), ...
        'spotPitch', spotPitch, ...
        'rotation', rotOut);
    
   q = setSet(gdata.oQ, ...
    'ID', ID(~isRef), ...
    'arrayRow', arrayRow(~isRef), ...
    'arrayCol', arrayCol(~isRef));
            
    % These are the initial coordinates, refined based on the ref spots
    [xSub, ySub] = coordinates(arrayRefined, mpRefs);
    for pass = 1:maxSubIter
        [qSub, spotPitch, mpSub] = segmentAndRefine(I(:,:,iGrid), S0, arrayRefined, q, xSub, ySub, gdata.iniPars); 
       
        % if spots are not correctly detected, iterate global position with
        % respect to the refs.
         bFound = ~get(qSub, 'isReplaced');
        if any(~bFound)                  
            delta = norm(mpSub - mpRefs)/spotPitch;           
            if delta > maxRefSubOffset
                warning(['delta ref-sub: ', num2str(delta), ', start refinement attempt']) 
                % if the substrate midpoint is to far from the ref
                % midpoint, re-do
                [xSub,ySub] = coordinates(array2fit, mpSub);
                mpRefs = mpSub;
            else
                break;
            end
            
        else
            break;
        end
        
            
    end
    qAll(~isRef) = qSub;
end

qAll = check4BadSpots(qAll, ...
    'mindiameter', spotPitch * gdata.iniPars.minDiameter, ...
    'maxdiameter', spotPitch * gdata.iniPars.maxDiameter, ...
    'maxaspectRatio', gdata.iniPars.maxAspectRatio, ...
    'minformFactor', gdata.iniPars.minFormFactor, ...
    'maxpositionDelta',spotPitch * gdata.iniPars.maxOffset);

qAll = replaceBadSpots(qAll);
       

clear qRefs
clear qSub
for i=1:nImages
    qImage(:,:,i) = quantify(qAll, I(:,:,i));
end
gdata.qImage = qImage;
%gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch);
%--------------------------------------------------------------------------
function gdata = seriesAdapt(gdata, I)

% first perform a standard fixed segmentation on the grid image
nImages = size(I,3);
rSize = [gdata.iniPars.xResize, gdata.iniPars.yResize];
if isequal(gdata.gridMode, 'kinLast')
    iGrid = nImages;
elseif isequal(gdata.gridMode, 'kinFirst')
    iGrid = 1;
end
fixedData = seriesFixed(gdata, I(:,:,iGrid));
rsizFactor = rSize./size(I(:,:,iGrid));
spotPitch = get(fixedData.oArray, 'spotPitch');
spotSize = get(fixedData.oArray , 'spotSize');

gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));
oPP = rescale(gdata.oP, rsizFactor(1));

bRef = get(gdata.oArray, 'isreference');
S0 = set(gdata.oS, 'spotPitch', spotPitch);
% get the principal segmentation from the fixedData:
ps = get(fixedData.qImage, 'oSegmentation');
% convert from cell array to normal array:
principalSegmentation = [ps{:}];
% find the midpoint associated with the principalSegmentation:
[x0, y0] = getPosition(fixedData.qImage);
mp0 = midPoint(fixedData.oArray, x0, y0);

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
    sRefs = segment(S0, I(:,:,i), x(bRef), y(bRef), rotOut);
    pRefs = setPropertiesFromSegmentation(spotProperties, sRefs);
    
    % find the position midpoint
    qRefs = setSet(gdata.oQ, 'oSegmentation', sRefs, 'oProperties', pRefs);
    [xPos, yPos] = getPosition(qRefs);
    mp = midPoint(fixedData.oArray, xPos, yPos);
    % shift the entire principal segmentation based on mp shift found
    coS = shift(principalSegmentation,mp - mp0);
    qImage(:,:,i) = setSet(fixedData.qImage,'oSegmentation', coS');
    % and Quantify
    qImage(:,:,i) = quantify(qImage(:,:,i), I(:,:,i));
end
gdata.qImage = qImage;
% scale the array object back for next run
gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);
%-----------------------------------------------------------------


function [qOut, spotPitch, mp] = segmentAndRefine(I, S0, array2fit, q, x, y, iniPars)
% Segments and attempts to refine the spotpitch
maxSegIter = 2;
maxPrimaryOffset = iniPars.maxOffset * 1.2;

oS = repmat(S0, size(x));
spotPitch = get(array2fit, 'spotPitch');
rotOut = get(array2fit, 'rotation');
bSegment = true(size(x));
for pass = 1:maxSegIter   
    oS(bSegment) = segment(S0, I, x(bSegment), y(bSegment),rotOut);
    % QC
    oProps = setPropertiesFromSegmentation(spotProperties, oS);
    % create the quantification object
    q = setSet(q,   'oSegmentation', oS, ...
        'oProperties', oProps);
                        
    q = check4EmptySpots(q);
    q = replaceEmptySpots(q);
    q = check4BadSpots(q, 'mindiameter', spotPitch * iniPars.minDiameter, ...
        'maxdiameter', spotPitch * iniPars.maxDiameter, ...
        'maxaspectRatio', iniPars.maxAspectRatio, ...
        'minformFactor', iniPars.minFormFactor, ...
        'maxpositionDelta',spotPitch * maxPrimaryOffset);%iniPars.maxOffset);
                
    q = replaceBadSpots(q);
    % When a minmimum nr of spots are correctly found 
    % Use these to refine the spotpitch
    bFound = ~get(q, 'isReplaced');
    if length(find(bFound)) > 1 
        [xPos, yPos] = getPosition(q);
        % refine the spotPitch and array midpoint
        array2fit = set(array2fit, 'isreference', bFound);
        arrayRefined = refinePitch(array2fit, xPos, yPos);
        spotPitch = get(arrayRefined, 'spotPitch');
        mp = midPoint(arrayRefined, xPos, yPos);
        % calculate array coordinates based on refined pitch                                                             
        [xRef,yRef] = coordinates(arrayRefined, mp);
    else
        break;
    end
    % if necessary go for a another pass to retry the spots that
    % were not correctly semented on the first pass, using the refined
    % pitch
    if any(~bFound)
        bSegment = ~bFound;
    else
        break;
    end
end
qOut = q;