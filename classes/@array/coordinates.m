function [cx,cy] = coordinates(oArray,mp, rotation)
if isempty(oArray.xOffset)
    oArray.xOffset = zeros(size(oArray.row));
end
if isempty(oArray.yOffset)
    oArray.yOffset = zeros(size(oArray.col));
end

if nargin < 3
    rotation = oArray.rotation;
end

% get the coordinates for set1, set2 respectivley
bSet1 = oArray.row > 0 & oArray.col > 0;
bSet2 = ~bSet1;
cx = -ones(size(bSet1));
cy = -ones(size(cx));
if any(bSet1)
    [cx(bSet1), cy(bSet1)] = gridCoordinates(oArray.row(bSet1), oArray.col(bSet1), oArray.xOffset(bSet1), oArray.yOffset(bSet1), mp, oArray.spotPitch, rotation);
end
if any(bSet2)
    [cx(bSet2), cy(bSet2)] = gridCoordinates(oArray.row(bSet2), oArray.col(bSet2), oArray.xOffset(bSet2), oArray.yOffset(bSet2), mp, oArray.spotPitch, rotation);
end
        


