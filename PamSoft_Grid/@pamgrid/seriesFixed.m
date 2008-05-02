function q = seriesFixed(pgr, I, varargin)
% function q = seriesFixed(pgr, I, varargin)
% Analysis of image series with:
% Global gridding on a fixed image
% Local spot finding on a fixed image
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

[x,y,rot] = globalGrid(pgr, I, 'exposure', exp, ...
                               'cycle', cycle);

                           
% produce the segmentation image

switch pgr.useImage
    case 'Last'
        Iseg = I(:,:, end);
    case 'Refs on First then Last'
        Iseg = I(:,:,end);
    case 'First'
        Iseg = I(:,:,1);
    case 'All'
        % combined segmentation image
        spgr = pgr;
        spgr.gridImageSize = size(I(:,:,1));
        spgr.oPreprocessing = preProcess('nSmallDisk', 0, ...
                                         'nLargeDisk', 0);
 
        Iseg = createGridImage(spgr, I, 'exposure', exp, ...
                                        'cycle', cycle);
                                    
end
qSegmented = segmentImage(pgr, Iseg, x, y, rot);
for i=1:size(I,3)
    q(:,i) = quantify(qSegmented, I(:,:,i));
end

                                    
                                    
        
        
                           

        