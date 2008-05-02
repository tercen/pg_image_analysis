function q = seriesAdaptGlobal(pgr, I, varargin)
opdef.cycle = [];
opdef.exposure = [];
op = setVarArginOptions(opdef, [], varargin{:});
% function q = seriesAdaptGlobal(pgr, I, varargin)
% analysis of image series with:
% global grid repeated on each image of the series
% local spot finding on a fixed image
if isempty(op.cycle)
    op.cycle = 1:size(I,3);
end
if isempty(op.exposure)
    op.exposure = ones(size(op.cycle));
end

[cycle, iSort] = sort(op.cycle);
exp = op.exposure(iSort);
I = I(:, :, iSort);

switch pgr.useImage
    case 'All'
        error('property ''useImage'' can not be ''All'' when using adaptive gridding, use ''seriesMode'' = ''Fixed''');        
end

% first perform a standard fixed segmentation
[x,y,rot] = globalGrid(pgr, I, 'exposure', exp, ...
                               'cycle', cycle);
% produce the segmentation image
switch pgr.useImage
    case 'Last'
        Iseg = I(:,:, end);
    case 'First then Last'
        Iseg = I(:,:,end);
    case 'First'
        Iseg = I(:,:,1);
    case ' All'
        error('property ''useImage'' can not be ''All'' when using adaptive gridding, use ''seriesMode'' = ''Fixed''');   
                                    
end
qFixed = segmentImage(pgr, Iseg, x, y, rot);
% get this principal segmentation from the fixed data
s0 = get(qFixed, 'oSegmentation');
s0 = [s0{:}]';% convert to array of segmentation objects
% and get the midpoint mp0 associated with s0
% Note that the midpoint will be calculated based on the
% refs only (standard behaviour of array.midPoint)
[x0, y0] = getPosition(s0);
mp0 = midPoint(pgr.oArray, x0, y0);
% prepare for segmenting the other images.
bRef = get(pgr.oArray, 'isreference');
spPitch = get(pgr.oArray, 'spotPitch');
os = set(pgr.oSegmentation, 'spotPitch',spPitch); 

for i=1:size(I,3)
    % global grid finding 
    [x,y,rot] = globalGrid(pgr, I(:,:,i), 'exposure', exp(i), ...
                               'cycle', cycle(i));
     % re-segment the refs only, find the midpoint associated with this
     % segmentation. Note that the midpoint will be calculated based on the
     % refs only (standard behaviour of array.midPoint)
     s0(bRef) = segment(os, I(:,:,i), x(bRef), y(bRef), rot);
     [x1, y1] = getPosition(s0);
     mp1 = midPoint(pgr.oArray, x1, y1);
     %shift the entire principal segmentation based on mp shift found
     s0s = shift(s0,mp1 - mp0);
     qImage = setSet(qFixed,'oSegmentation', s0s);
     % and quantify for final output
     q(:,i) = quantify(qImage, I(:,:,i));
end

  

