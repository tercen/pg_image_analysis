function [cx,cy] = coordinates(oArray,mp, rotation)
[cx,cy] = gridCoordinates(oArray.row, oArray.col, oArray.xOffset, oArray.yOffset, mp, oArray.spotPitch, rotation);

