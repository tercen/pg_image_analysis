function outSeg = segmentByThreshold(oS, I, cx, cy, rotation)
[nRows, nCols] = size(cx);
% infer the average spotpitch from cx and cy
xPitch = diff(cx);xPitch = mean(xPitch(:));
yPitch = diff(cy');yPitch = mean(yPitch(:));
spotPitch = mean([xPitch, yPitch]);
% then the left upper coordinates and right lower coordinates
xLu = round(cx - spotPitch);
yLu = round(cy - spotPitch);
xRl = round(cx + spotPitch);
yRl = round(cy + spotPitch);
% make sure these are in the image
xLu(xLu<1) = 1;
yLu(yLu<1) = 1;
xRl(xRl > size(I,1)) = size(I,1);
yRl(yRl > size(I,2)) = size(I,2);

% apply morphological filtering if required.
if oS.nFilterDisk >= 1
    se = strel('disk', round(oS.nFilterDisk/2));
    I  = imerode(I, se);
    I  = imdilate(I, se);
end
% do the edge detection:
Iedge = edge(I, 'canny', [0, 0.007]);


pixAreaSize = oS.areaSize * spotPitch;
pixOff = round(max(spotPitch -0.5*pixAreaSize,0));
spotPitch = round(spotPitch);

for i  = 1:nRows
    for j = 1:nCols
        % store the results in nRows, nCols array of segmentation objects
        outSeg(i,j) = oS;
        fittedMidpoint = [0,0];
        areaMidpoint = [2,2];
        xLocal = round(xLu(i,j) + [0, 2*spotPitch]);
        yLocal = round(yLu(i,j) + [0, 2*spotPitch]);
        while ~all(abs(fittedMidpoint - areaMidpoint) <= 1)
            Ilocal = Iedge(xLocal(1):xLocal(2),yLocal(1):yLocal(2));
            % center in the local image.
            Iinitial = Ilocal(pixOff:end-pixOff, pixOff:end-pixOff);
            areaMidpoint = round(size(Iinitial)/2);
            [x,y] = find(Iinitial);
            if length(x) < 6
                outSeg(i,j).cLu = [];
                break;
            end
            [x0, y0, r] = circfit(x,y);
            fittedMidpoint = round([x0, y0]);
            [xFit, yFit] = circle(x0, y0, r, length(x));
            outSeg(i,j).cLu = [xFit, yFit];
            mpOffset = areaMidpoint - fittedMidpoint;
            xLocal = xLocal - mpOffset(1);
            yLocal = yLocal - mpOffset(2);    
        end
        outSeg(i,j).binSpot = Iinitial;
    end
end




