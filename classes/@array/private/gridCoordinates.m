function [x,y, ix, iy] = gridCoordinates(mp, refMask, spotPitch, rotation, x0, y0)
% function [x,y, ix, iy] = gridCoordinates(mp, refMask, spotPitch, rotation, x0, y0)
% this function generates the coordinates of spots in a grid.
% IN:
%
% mp: two component vector with the x and y coordinate of the midpoint of
% the array in the image or template.
%
% refMask: array (size = [nRow, nCol[), each element corresponding to a
% position in the grid, element = 1 if a coordinate for the corresponding position is required, 0 otherwise.
%
% spotPitch (2 element vector) x and y pitch of the array, if spotPitch is
% scalar the function use spotPitch for both the x and y pitch.
%
% rotation (scalar) rotation of the arry
%
% x0: array of size refMask containing offsets from ideal x coordinate for individual
% positions. x0 = [] dfts to x0 = zeros(size(refMask));
% y0, see x0
%
% OUT:
% x,y coordinates of positions
% ix, iy, row, col indices corresponding to the entries in x and y.

[nRows, nCols] = size(refMask);
[ix,iy] = find(refMask);
% if offsets from ideal are entered use these , if empty use zeros
if isempty(x0)
    x0 = zeros(size(refMask));
end
if isempty(y0)
    y0 = zeros(size(refMask));
end

% convert to linear index
iReq = sub2ind(size(refMask), ix, iy);
iX0 = x0(iReq);
iY0 = y0(iReq);

% 
if length(spotPitch) == 1
    spotPitch(2) = spotPitch(1);
end
% calculate grid coordinates, zeros centered
x = spotPitch(1)*(ix-mean(1:nRows)) + spotPitch(1) * iX0;
y = spotPitch(2)*(iy-mean(1:nCols)) + spotPitch(2) * iY0;

% rotate the grid
teta = (2*pi/360) * rotation;
R = [cos(teta), -sin(teta);
    sin(teta), cos(teta)];

for i=1:length(x)
    v = R*[x(i);y(i)];
    x(i) = v(1);
    y(i) = v(2);
end

% center around midpoint of array in image or template
x = mp(1) + x + 1;
y = mp(2) + y + 1;
%EOF