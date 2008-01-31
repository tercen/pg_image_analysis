function q = seriesAdaptLocal(pgr, I, varargin)
% function q = seriesAdaptLocal(pgr, I, varargin)
% analysis of image series with:
% global grid finding on fixed image
% local spot finding repeated on each image
opdef.cycle = [];
opdef.exposure = [];
op = setVarArginOptions(opdef, [], varargin{:});

% sort images to cycle
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
[x,y,rot] = globalGrid(pgr, I, 'exposure', exp, ...
                               'cycle', cycle);

for i=1:size(I,3)
    qSegmented = segmentImage(pgr, I(:,:,i), x, y, rot);
    q(:,i) = quantify(qSegmented, I(:,:,i));
end
                           

