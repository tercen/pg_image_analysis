function [x,y, ix, iy] = gridCoordinates(mp, refMask, spotPitch, rotation)


[nRows, nCols] = size(refMask);
[ix,iy] = find(refMask);

if length(spotPitch) == 1
    spotPitch(2) = spotPitch(1);
end


x = spotPitch(1)*(ix-mean(1:nRows));
y = spotPitch(2)*(iy-mean(1:nCols));

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
x = mp(1) + x + 1;
y = mp(2) + y + 1;