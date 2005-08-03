function [x,y, ix, iy] = gridCoordinates(mp, refMask, spotPitch, rotation, x0, y0)


[nRows, nCols] = size(refMask);
[ix,iy] = find(refMask);

% if offsets from ideal are entered use these , if empty use zeros
if isempty(x0)
    x0 = zeros(size(refMask));
end

if isempty(y0)
    y0 = zeros(size(refMask));
end

iReq = sub2ind(size(refMask), ix, iy);
iX0 = x0(iReq);
iY0 = y0(iReq);

if length(spotPitch) == 1
    spotPitch(2) = spotPitch(1);
end

% calculate grid coordinates, zeros centered
x = spotPitch(1)*(ix-mean(1:nRows)) + spotPitch(1) * iX0;
y = spotPitch(2)*(iy-mean(1:nCols)) + spotPitch(2) * iY0;

% if required, calculate coordinates for rotated grids
if nargin > 3
    teta = (2*pi/360) * rotation;   
    R = [cos(teta), -sin(teta); 
         sin(teta), cos(teta)];
    
    for i=1:length(x)
        v = R*[x(i);y(i)];
        x(i) = v(1);
        y(i) = v(2);
    end
end

% center around image midpoint.
x = mp(1) + x + 1;
y = mp(2) + y + 1;