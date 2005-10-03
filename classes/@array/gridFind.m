function [x,y, rot, g] = gridFind(g, I)
% array.gridFind
% function [x,y,rot,oArrayOut] = gridFind(oArray, I)
% IN:
% oArray, grid object as defined by oArray = array(args)
% I, image to find the grid on.
% OUT:
% x [nRow, nCol] , x(i,j) is the x coordinate of spot(i,j)
% y [nRow, nCol] , y(i,j) is the y coordinate of spot(i,j)
% rot, optimal rotation out of the rotation axis supplied to the grid
% object
% oArrayOut: updated grid object, in case of array.method = 'corelation2D' the first
% call of the gridFind function will be much slower than subsequent calls
% with the updated object.
% See also array/array, array/fromfile
%
% method: 'correlation2D', uses 2D template correlation to find the
% location of the grid.

% check if required parameters have been set
if isempty(g.mask)
    error('Parameter ''mask'' has not been set.');
end
if isempty(g.spotPitch)
    error('Parameter ''spotPitch'' has not been set.');
end
if isempty(g.spotSize)
    error('Parameter ''spotSize'' has not been set.');
end

if ~isempty(g.xOffset) & size(g.xOffset) ~= size(g.mask)
    error('Dimensions of parameter ''xOffset'' must be the same as that of parameter ''mask''.');
end
if ~isempty(g.yOffset) & size(g.yOffset) ~= size(g.mask)
    error('Dimensions of parameter ''yOffset'' must be the same as that of parameter ''mask''.');
end

private = g.private;
switch g.method
    case 'correlation2D'
        % check if a template exists for the current grid object or
        % the template needs to be updated.
        if ~isfield(private, 'fftTemplate')
            % update template
            private(1).fftTemplate     = makeFFTTemplate(g, size(I));
            % store the current grid settings so it can be checked if the
            % template needs to be updated on the next call.
            private.mask            = g.mask;
            private.spotPitch       = g.spotPitch;
            private.spotSize        = g.spotSize;
            private.rotation        = g.rotation;
            private.imageSize       = size(I);
        elseif  ~isequal(private.mask, g.mask) || ...
                ~isequal(private.spotPitch, g.spotPitch) || ...
                ~isequal(private.spotSize,g.spotSize) || ...
                ~isequal(private.rotation,g.rotation) || ...
                ~isequal(private.imageSize, size(I))
                
            
                % template needs updating
                
            private.fftTemplate     = makeFFTTemplate(g, size(I));
            % store the current grid settings so it can be checked if the
            % template needs to be updated on the next call.
            private.mask            = g.mask;
            private.spotPitch       = g.spotPitch;
            private.spotSize        = g.spotSize;
            private.rotation        = g.rotation;
        end
        g.private  = private;
        
        [mx, iRot] = templateCorrelation(I, private.fftTemplate);
        rot = g.rotation(iRot);
        [cx, cy, ix,iy] = gridCoordinates(mx, ones(size(g.mask)), g.spotPitch, rot, g.xOffset, g.yOffset);
        x = -ones(size(g.mask));
        for i=1:length(cx)
            x(ix(i), iy(i)) = cx(i)-2;
            y(ix(i), iy(i)) = cy(i)-2;
        end
        
        
    otherwise
        error('Unknown value for grid property ''method''');
end
