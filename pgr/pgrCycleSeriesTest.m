function qFinal = pgrCycleSeriesTest(I, oP, oArray, oS0, oQ0, settings)
                 
if settings.seriesMode == 0
    qFinal = seriesFixed(I, oP, oArray, oS0, oQ0, settings);    
elseif  settings.seriesMode ==1
    qFinal = seriesAdaptGlobal(I, oP, oArray, oS0, oQ0, settings);
elseif settings.seriesMode == 2
    qFinal = seriesAdaptLocal(I, oP, oArray, oS0, oQ0, settings);
elseif settings.seriesMode == 3
    qFinal = seriesAdapt(I, oP, oArray, oS0, oQ0, settings);
else
    error('Invalid value for series mode');
end

% ------------------------------------------------------------------------
function qOut = seriesFixed(I, oP, oArray, oS0, oQ0, settings)
% gridding with segmentation fixed on gridImage
nImages = size(I,3);
rSize = settings.resize;
% set the grid Image
if nImages > 1
    iGrid = settings.nGridImage;
    iSeg  = settings.nSegImage;
else 
    iGrid = 1;
    iSeg = 1;
end

[xg,yg,rotOut]= globalGrid(I(:,:,iGrid), oArray, oP, rSize);
q = segmentImage(I(:,:,iSeg), oS0, oQ0, oArray, xg, yg, rotOut, ...
                           settings.sqc, ...
                           settings.optimizeSpotPitch, ...
                           settings.optimizeRefVsSub);

qOut = seriesQuantify(q, I);

%--------------------------------------------------------------------------
function q = seriesQuantify(qIn, I)
nImages = size(I,3);
for i=1:nImages
    q(:,:,i) = quantify(qIn, I(:,:,i));
end

function qOut = seriesAdapt(I, oP, oArray, oS0, oQ0, settings)
rSize = settings.resize;
nImages = size(I,3);
if nImages > 1
    iGrid = settings.nGridImage;
    iSeg  = settings.nSegImage;
else 
    iGrid = 1;
    iSeg = 1;
end

for i=1:nImages
    [xg,yg, rotOut] = globalGrid(I(:,:, iGrid), oArray, oP, rSize);
    q = segmentImage(I(:,:,i), oS0, oQ0, oArray, xg, yg, rotOut, ... 
                              settings.sqc, ...
                              settings.optimizeSpotPitch, ...
                              settings.optimizeRefVsSub);
                          
    qOut(:,:,i) = quantify(q, I(:,:,i));
end

function qOut = seriesAdaptLocal(I, oP, oArray, oS0, oQ0, settings)
rSize = settings.resize;
nImages = size(I,3);
if nImages > 1
    iGrid = settings.nGridImage;
    iSeg  = settings.nSegImage;
else 
    iGrid = 1;
    iSeg = 1;
end
[xg,yg, rotOut] = globalGrid(I(:,:, iGrid), oArray, oP, rSize);

for i=1:nImages
    q = segmentImage(I(:,:,i), oS0, oQ0, oArray, xg, yg, rotOut, ...
            settings.sqc, ...
            settings.optimizeSpotPitch, ...
            settings.optimizeRefVsSub);
        
    qOut(:,:,i) = quantify(q, I(:,:,i));
end

function qFinal = seriesAdaptGlobal(I, oP, oArray, oS0, oQ0, settings)
rSize = settings.resize;
nImages = size(I,3);
if nImages > 1
    iGrid = settings.nGridImage;
    iSeg  = settings.nSegImage;
else 
    iGrid = 1;
    iSeg = 1;
end

% first perform a standard fixed segmentation on the grid image
[xg,yg, rotOut] = globalGrid(I(:,:, iGrid), oArray, oP, rSize);
qFixed = segmentImage(I(:,:,iSeg), oS0, oQ0, oArray, xg, yg, rotOut, ..., 
            settings.sqc, ...
            settings.optimizeSpotPitch, ...
            settings.optimizeRefVsSub);


spotPitch = get(oArray, 'spotPitch');
bRef = get(oArray, 'isreference');
S0 = set(oS0, 'spotPitch', spotPitch);
% get the principal segmentation from the fixedData:
ps = get(qFixed, 'oSegmentation');
% convert from cell array to normal array:
principalSegmentation = [ps{:}]';
% find the midpoint associated with the principalSegmentation:
[x0, y0] = getPosition(qFixed);
%array2fit = removePositions(oArray, '~isreference');
mp0 = midPoint(oArray, x0, y0);

for i=1:nImages
   [x,y,rotOut] = globalGrid(I(:,:,i), oArray, oP, rSize);
    % resegment the refs only
    principalSegmentation(bRef) = segment(S0, I(:,:,i), x(bRef), y(bRef), rotOut);
    pRefs = setPropertiesFromSegmentation(spotProperties, principalSegmentation(bRef));
    % find the position midpoint
   
    
    qFixed(bRef) = setSet(qFixed(bRef), 'oSegmentation', principalSegmentation(bRef) , ... 
                                'oProperties', pRefs);
    [xPos, yPos] = getPosition(qFixed);
    %array2fit = removePositions(oArray, '~isreference');

    mp = midPoint(oArray, xPos, yPos);
    % shift the entire principal segmentation based on mp shift found
    coS = shift(principalSegmentation,mp - mp0);
    qImage(:,:,i) = setSet(qFixed,'oSegmentation', coS);
    % and Quantify
    qImage(:,:,i) = quantify(qImage(:,:,i), I(:,:,i));
end
qFinal = qImage;

%-----------------------------------------------------------------
function [q, spotPitch, mp] = segmentAndRefine(I, S0, array2fit, q, x, y, iniPars, fOptimizeSpotPitch)
% Segments and attempts to refine the spotpitch
 if fOptimizeSpotPitch
    % this determines if (a) spotPitch refinement iteration(s) will be
    % performed
    maxIter = 2;
 else
    maxIter = 1;
 end
 
maxPrimaryOffset = iniPars.maxOffset * 1.2;
maxDelta = 0.3;
oS = repmat(S0, size(x));
spotPitch = get(array2fit, 'spotPitch');
refSpotPitch = 0;

mp = midPoint(array2fit, x,y);
rotOut = get(array2fit, 'rotation');

fxdx = get(array2fit, 'xFixedPosition');
bFixedSpot = fxdx ~= 0;

% start the refinemnet loop, terminate when the refinedSpotPitch is close
% enough to the input spotPitch  (or when maxIter is reached);
iter = 0;
delta = maxDelta + 1;
while delta > maxDelta   
    iter = iter + 1;
    if iter > maxIter
        break;
    end
    S0 = set(S0, 'spotPitch', spotPitch);
    oS = segment(S0, I, x, y,rotOut);
    % QC
    oProps = setPropertiesFromSegmentation(spotProperties, oS);
    % create the quantification object
    q = setSet(q,    'oSegmentation', oS, ...
                     'oProperties', oProps, ...
                     'isReplaced', false(size(q)), ...
                     'isEmpty', false(size(q)), ...
                     'isBad', false(size(q)));                 
    q = check4EmptySpots(q);
    q = replaceEmptySpots(q);
    q = check4BadSpots(q, 'mindiameter', spotPitch * iniPars.minDiameter, ...
        'maxdiameter', spotPitch * iniPars.maxDiameter, ...
        'maxaspectRatio', iniPars.maxAspectRatio, ...
        'minformFactor', iniPars.minFormFactor, ...
        'maxpositionDelta',spotPitch * maxPrimaryOffset);%iniPars.maxOffset);
                
    q = replaceBadSpots(q);
    % if all spots are fixed spots, skip spot pitch refinement here here
    if all(bFixedSpot)
        break;
    end
    % if too little spots are correctly found, skip spot pitch refinement
    % here:
     bFound = ~get(q, 'isReplaced');
    if length(find(bFound)) <= 5
        break;
    end
  % Use the spots found to refine the pitch and array midpoint
  % exclude fixed points from the refinement 

  
  [xPos, yPos] = getPosition(q);

  array2fit = set(array2fit, 'isreference', ~bFixedSpot);

  
  arrayRefined = refinePitch(array2fit, xPos, yPos);
  refSpotPitch = get(arrayRefined, 'spotPitch');  

  delta = abs(refSpotPitch - spotPitch);
  
  
  mp = midPoint(arrayRefined, xPos, yPos);

  
  % calculate array coordinates based on refined pitch
  [xr,yr] = coordinates(arrayRefined, mp);
  
  disp(['iter ',num2str(iter)]);
  disp(['delta: ', num2str(delta)]);
  disp(['sp in: ', num2str(spotPitch)]);
  disp(['sp out: ', num2str(refSpotPitch)]);
 
  spotPitch = refSpotPitch;
  x(~bFixedSpot) = xr(~bFixedSpot);
  y(~bFixedSpot) = yr(~bFixedSpot); 
end

% reset flags and final qc
% q = setSet(q, 'isReplaced', false(size(q)), 'isEmpty', false(size(q)), 'isBad', false(size(q)));
q = check4BadSpots(q, 'maxpositionDelta',spotPitch * iniPars.maxOffset);
q = replaceBadSpots(q);  

 function [x,y,rotOut] = globalGrid(I, oArray, oP, rSize)
% reduce the numver of pixels for efficiency (resize), preprocessing and grid finding
rsizFactor = rSize./size(I);
oPP = rescale(oP, rsizFactor(1));
Igrid = getPrepImage(oPP, imresize(I, rSize));

srchRoi = get(oArray, 'roiSearch');
if ~isempty(srchRoi)
    srchRoi = imresize(srchRoi, rSize);
end

spotPitch   = get(oArray, 'spotPitch');
spotSize    = get(oArray, 'spotSize');
xfxd =  get(oArray,   'xFixedPosition');
yfxd =  get(oArray,   'yFixedPosition');

oArray = set(oArray, 'spotPitch', spotPitch * rsizFactor , ...
                     'spotSize', spotSize * rsizFactor(1) , ...
                     'xFixedPosition', xfxd * rsizFactor(1), ...
                     'yFixedPosition', yfxd * rsizFactor(2), ...
                     'roiSearch', srchRoi);


[x,y,rotOut] = gridFind(oArray, Igrid);

x = x/rsizFactor(1);
y = y/rsizFactor(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

function q = segmentImage(I, oS0, oQ0, oArray, x, y, rot,  sqc, fOpPitch, fOpRefSub)

if fOpRefSub
    % parse inputs the function that perfroms the segmentation and refines
    % - if necessary -
    % the position of the sub array versus that of the ref array
    q = sSegmentImage_RefineRefVsSub(I, oS0, oQ0, oArray, x, y, rot,  sqc, fOpPitch);
else
     % segmentation without optimization
     q = sSegmentImage(I, oS0, oQ0, oArray, x, y, rot,  sqc, fOpPitch);
end

function qOut = sSegmentImage(I, oS0, oQ0, oArray, x, y, rot,  sqc, fOpPitch)
spotPitch = get(oArray, 'spotPitch');
S0 = set(oS0, 'spotPitch', spotPitch);
arrayRow = get(oArray, 'row');
arrayCol = get(oArray, 'col');
ID = get(oArray, 'ID');
oArray = set(oArray, 'rotation', rot);
q = setSet(oQ0, ...
    'ID', ID, ...
    'arrayRow', arrayRow, ...
    'arrayCol', arrayCol);
     
qOut = segmentAndRefine(I, S0,oArray, q, x, y, sqc, fOpPitch); 
  
  
function qOut = sSegmentImage_RefineRefVsSub(I, oS0, oQ0, oArray, x, y, rot,  sqc, fOpPitch)
maxSubIter = 2; % Max iterations for subs vs refs refinement 
maxRefSubOffset = 0.15; % Max offset criterium between refs and subs.
% SEGMENTATION

spotPitch = get(oArray, 'spotPitch');
S0 = set(oS0, 'spotPitch', spotPitch);

isRef = get(oArray, 'isreference');

% pre-allocate the array of segmentation objects:
% initalize some variables

xRef = x(isRef);
yRef = y(isRef);

arrayRow = get(oArray, 'row');
arrayCol = get(oArray, 'col');
xOff = get(oArray, 'xOffset');
yOff = get(oArray, 'yOffset');
xfxd = get(oArray, 'xFixedPosition');
yfxd = get(oArray, 'yFixedPosition');

ID = get(oArray, 'ID');

% preallocate array of spotQuantification objects.
qOut = repmat(spotQuantification, size(arrayRow));

% first segmentation pass is for refs only
array2fit = array(  'row', arrayRow(isRef), ...
    'col', arrayCol(isRef), ...
    'isreference', isRef(isRef), ...
    'xOffset', xOff(isRef), ...
    'yOffset', yOff(isRef), ...
    'xFixedPosition', xfxd(isRef), ...
    'yFixedPosition', yfxd(isRef), ...
    'spotPitch', spotPitch, ...
    'rotation', rot);

q = setSet(oQ0, ...
    'ID', ID(isRef), ...
    'arrayRow', arrayRow(isRef), ...
    'arrayCol', arrayCol(isRef));


[qRefs, refSpotPitch, mpRefs]  = segmentAndRefine(I, S0, array2fit, q, xRef, yRef, sqc, fOpPitch);


qOut(isRef) = qRefs; % refs are quantified!

% if any, segment and quantify the substrates (non refs), allow for another
% pass if the offset between resf and sub is to large
bFixedSpot = xfxd > 0; % not refined spots
if any(~isRef)
    arrayRefined = array(...
        'row', arrayRow(~isRef), ...
        'col', arrayCol(~isRef), ...
        'isreference', ~isRef(~isRef), ... % set the ref prop to on to enable mp etc calculation
        'xOffset', xOff(~isRef), ...
        'yOffset', yOff(~isRef), ...
        'xFixedPosition', xfxd(~isRef), ...
        'yFixedPosition', yfxd(~isRef), ...
        'spotPitch', spotPitch, ...
        'rotation', rot);
    
   q = setSet(oQ0, ...
    'ID', ID(~isRef), ...
    'arrayRow', arrayRow(~isRef), ...
    'arrayCol', arrayCol(~isRef));
            
    % These are the initial coordinates, refined based on the ref spots
    [xSub, ySub] = coordinates(arrayRefined, mpRefs);
    for pass = 1:maxSubIter
        [qSub, spotPitch, mpSub] = segmentAndRefine(I, S0, arrayRefined, q, xSub, ySub, sqc, fOpPitch); 
   
        % if spots are not correctly detected, iterate global position with
        % respect to the refs.
        bFound = ~get(qSub, 'isReplaced');
        if any(~bFound & ~bFixedSpot(~isRef)) || all(bFixedSpot)           
          
            delta = norm(mpSub - mpRefs)/spotPitch;           
            if delta > maxRefSubOffset
                warning(['delta ref-sub: ', num2str(delta), ', start refinement attempt']) 
                % if the substrate midpoint is to far from the ref
                % midpoint, re-do
                [xr,yr] = coordinates(arrayRefined, mpSub); % get expected coordinates from first pass midpoint
                xSub(~bFixedSpot(~isRef)) = xr(~bFixedSpot(~isRef)); % adapt the ~bFixedSpot coordinates 
                ySub(~bFixedSpot(~isRef)) = yr(~bFixedSpot(~isRef)); 
                mpRefs = mpSub;
            else
                break;
            end
            
        else
            break;
        end
        
            
    end
    qOut(~isRef) = qSub;
end