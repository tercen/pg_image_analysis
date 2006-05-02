function [cx,cy] = coordinates(oArray,mp, rotation)
[x,y, subx, suby] = gridCoordinates(mp, oArray.mask, oArray.spotPitch, rotation, oArray.xOffset, oArray.yOffset);

iLin = sub2ind(size(oArray.mask), subx, suby);
cx = zeros(size(oArray.mask));
cx(iLin) = x;
cy = zeros(size(cx));
cy(iLin) = y;
% EOF