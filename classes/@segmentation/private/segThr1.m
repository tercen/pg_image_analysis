function spots = segThr1(I, cx,cy, spotAreaSize)

[nRows, nCols] = size(cx);
for i = 1:nRows
    for j=1:nCols
        cLu  = round([cx(i,j), cy(i,j)] - (spotAreaSize/2));
        xLu = cLu(1);
        yLu = cLu(2);
        xRl = round(xLu + spotAreaSize);
        yRl = round(yLu + spotAreaSize);
        Ispot = I(xLu:xRl, yLu:yRl);
        [level, eps] = graythresh(Ispot);
        spots(i,j).cLu = [xLu, yLu];
        spots(i,j).binSpot = im2bw(Ispot, level);
        spots(i,j).eps  = eps;
    end
end
