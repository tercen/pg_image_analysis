function [qFinal, oArray] = pgrCycleSeries(I, oP, oArray, oS0, oQ0, settings)

                    
if settings.seriesMode == 0
    [qFinal, oArray] = seriesFixed(I, oP, oArray, oS0, oQ0, settings);
elseif  settings.seriesMode ==1
    [qFinal, oArray] = seriesAdapt(I, oP, oArray, oS0, oQ0, settings);
else
    error('Invalid value for series mode');
end

% ------------------------------------------------------------------------
function [qFinal, oArray] = seriesFixed(I, oP, oArray, oS0, oQ0, settings)

qcc = settings.sqc;
% here are some hardcoded settings:
maxSubIter = 2; % Max iterations for subs vs refs refinement 
maxRefSubOffset = 0.15; % Max offset criterium between refs and subs.

% gridding with segmentation fixed on gridImage
nImages = size(I,3);
rSize = settings.resize;
% set the grid Image
if nImages > 1
    iGrid = settings.nGridImage;
else 
    iGrid = 1;
end
% redusce the numver of pixels for efficiency (resize), preprocessing and grid finding
rsizFactor = rSize./size(I(:,:,iGrid));
oPP = rescale(oP, rsizFactor(1));
Igrid = getPrepImage(oPP, imresize(I(:,:,iGrid), rSize));
spotPitch   = get(oArray, 'spotPitch');
spotSize    = get(oArray, 'spotSize');
xfxd =  get(oArray,   'xFixedPosition');
yfxd =  get(oArray,   'yFixedPosition');

oArray = set(oArray, 'spotPitch', spotPitch * rsizFactor , ...
                     'spotSize', spotSize * rsizFactor(1) , ...
                     'xFixedPosition', xfxd * rsizFactor(1), ...
                     'yFixedPosition', yfxd * rsizFactor(2) );

[x,y,rotOut, oArray] = gridFind(oArray, Igrid);

% scale back to original image size, make sure the coordinate sare within the image 
oArray = set(oArray, 'spotPitch', spotPitch , ...
    'spotSize', spotSize, ...
    'xFixedPosition', xfxd, ...
    'yFixedPosition', yfxd);

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

% SEGMENTATION
S0 = set(oS0, 'spotPitch', spotPitch);

% first segment the references, refine te spot pitch, allow for another pass
% to segment references that were not segmented correctly on the first pass
% based on refined settings
isRef = get(oArray, 'isreference');

% pre-allocate the array of segmentation objects:
% initalize some variables

xRef = x(isRef);
yRef = y(isRef);
oS = repmat(S0, size(x(isRef)));
bSegment = true(size(oS));

arrayRow = get(oArray, 'row');
arrayCol = get(oArray, 'col');
xOff = get(oArray, 'xOffset');
yOff = get(oArray, 'yOffset');
ID = get(oArray, 'ID');

array2fit = array(  'row', arrayRow(isRef), ...
    'col', arrayCol(isRef), ...
    'isreference', isRef(isRef), ...
    'xOffset', xOff(isRef), ...
    'yOffset', yOff(isRef), ...
    'spotPitch', spotPitch, ...
    'rotation', rotOut);

q = setSet(oQ0, ...
    'ID', ID(isRef), ...
    'arrayRow', arrayRow(isRef), ...
    'arrayCol', arrayCol(isRef));

[qRefs, refSpotPitch, mpRefs]  = segmentAndRefine(I(:,:,iGrid), S0, array2fit, q, xRef, yRef, settings.sqc);

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
    
   q = setSet(oQ0, ...
    'ID', ID(~isRef), ...
    'arrayRow', arrayRow(~isRef), ...
    'arrayCol', arrayCol(~isRef));
            
    % These are the initial coordinates, refined based on the ref spots
    [xSub, ySub] = coordinates(arrayRefined, mpRefs);
    for pass = 1:maxSubIter
        [qSub, spotPitch, mpSub] = segmentAndRefine(I(:,:,iGrid), S0, arrayRefined, q, xSub, ySub, settings.sqc); 
       
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

% reset flags
qAll = setSet(qAll, 'isReplaced', false(size(qAll)), 'isBad', false(size(qAll)) );


qAll = check4BadSpots(qAll, ...
    'mindiameter', spotPitch * qcc.minDiameter, ...
    'maxdiameter', spotPitch * qcc.maxDiameter, ...
    'maxaspectRatio', qcc.maxAspectRatio, ...
    'minformFactor', qcc.minFormFactor, ...
    'maxpositionDelta',spotPitch * qcc.maxOffset);

qAll = replaceBadSpots(qAll);
       


clear qRefs
clear qSub
for i=1:nImages
    qImage(:,:,i) = quantify(qAll, I(:,:,i));
    %qImage(:,:,i) = check4EmptySpots(qImage(:,:,i), 'quantification');
end
qFinal = qImage;
%gdata.oArray = set(gdata.oArray, 'spotPitch', spotPitch);
%--------------------------------------------------------------------------
function [qFinal, foArray] = seriesAdapt(I, oP, oArray, oS0, oQ0, settings)

% first perform a standard fixed segmentation on the grid image
nImages = size(I,3);
rSize = settings.resize;
iGrid = settings.nGridImage;
[qFixed, foArray] = seriesFixed(I(:,:,iGrid), oP, oArray, oS0, oQ0, settings);

rsizFactor = rSize./size(I(:,:,iGrid));
spotPitch = get(foArray, 'spotPitch');
spotSize = get(foArray , 'spotSize');

scArray = set(foArray, 'spotPitch', spotPitch * rsizFactor , ...
            'spotSize', spotSize * rsizFactor(1));
oPP = rescale(oP, rsizFactor(1));

bRef = get(foArray, 'isreference');


S0 = set(oS0, 'spotPitch', spotPitch);
% get the principal segmentation from the fixedData:
ps = get(qFixed, 'oSegmentation');
% convert from cell array to normal array:
principalSegmentation = [ps{:}];
% find the midpoint associated with the principalSegmentation:
[x0, y0] = getPosition(qFixed);
array2fit = removePositions(foArray, '~isreference');
mp0 = midPoint(array2fit, x0, y0);

for i=1:nImages
    % now find the grid on the individual images, 
    Igrid = getPrepImage(oPP, imresize(I(:,:,i), rSize));
    [x,y,rotOut] = gridFind(scArray, Igrid);
    
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
    qRefs = setSet(oQ0, 'oSegmentation', sRefs, 'oProperties', pRefs);
    [xPos, yPos] = getPosition(qRefs);
    
    array2fit = removePositions(foArray, '~isreference');
    mp = midPoint(array2fit, xPos, yPos);
    % shift the entire principal segmentation based on mp shift found
    coS = shift(principalSegmentation,mp - mp0);
    qImage(:,:,i) = setSet(qFixed,'oSegmentation', coS');
    % and Quantify
    qImage(:,:,i) = quantify(qImage(:,:,i), I(:,:,i));
end
qFinal = qImage;
% scale the array object back for next run
foArray = set(foArray, 'spotPitch', spotPitch , ...
            'spotSize', spotSize);
%-----------------------------------------------------------------
function [qOut, spotPitch, mp] = segmentAndRefine(I, S0, array2fit, q, x, y, iniPars)
% Segments and attempts to refine the spotpitch
maxSegIter = 2;
maxPrimaryOffset = iniPars.maxOffset * 1.2;

oS = repmat(S0, size(x));
spotPitch = get(array2fit, 'spotPitch');
mp = midPoint(array2fit, x,y);

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
        [x,y] = coordinates(arrayRefined, mp);
    else
        break;
    end
    % if necessary go for a another pass to retry the spots that
    % were not correctly semented on the first pass, using the refined
    % pitch
    
    % recheck the poosition against a tighter spec
    q = check4BadSpots(q, 'maxpositionDelta',spotPitch * iniPars.maxOffset);
    q = replaceBadSpots(q);
    bSegment = get(q, 'isReplaced');            
    if ~any(bSegment)
        break;
    end
    
end
% reset all the flags
qOut = q;%setSet(q, 'isReplaced', false(size(q)), 'isEmpty', false(size(q)), 'isBad', false(size(q)));