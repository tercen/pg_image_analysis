function outSeg = segmentByThreshold(oS, I, cx, cy, rotation)
[nRows, nCols] = size(cx);
% infer the average spotpitch from cx and cy
xPitch = diff(cx');xPitch = mean(xPitch(:));
yPitch = diff(cy);yPitch = mean(yPitch(:));
spotPitch = mean(xPitch, yPitch);
% then the left upper coordinates and right lower coordinates
xLu = uint16(cx - spotPitch);
yLu = uint16(cy - spotPitch);
xRl = uint16(cx + spotPitch);
yRl = uint16(cy + spotPitch);
% make sure these are in the image
xLu(xLu<1) = 1;
yLu(yLu<1) = 1;
xRl(xRl > size(I,1)) = size(I,1);
yRl(yRl > size(I,2)) = size(I,2);

% retain the part of the image that contains the grid, at the expense of
% having to recaculate the xyLu but reduces the number of pixels in filtering.
I = I(xLu(1,1):xRl(end,end), yLu(1,1):yRl(end,end));
% left upper coordinates corresponding to the cropped image:
cxLu = xLu - xLu(1,1) + 1; cyLu = yLu - yLu(1,1) + 1;

% apply morphological filtering if required.
if os.nFilterDisk >= 1
    se = strel('disk', round(oS.nFilterDisk/2));
    I  = imerode(I, se);
    I  = imdilate(I, se);    
end

% Get full scale factor, necessary for auto thresholding
if isequal(class(I), 'uint8')
    bitRange = 255;
elseif isequal(class(I), 'uint16');
    bitRange = 65535;
else
    bitRange = 1;
end

% apply local thresholding
pixAreaSize = os.areaSize * spotPitch;
pixOff = round(min(spotPitch -0.5*pixAreaSize,0));

for i  = 1:nRows
    for j = 1:nCols
        % store the results in nRows, nCols array of segmentation objects
        outSeg(i,j) = oS;
        Ilocal = I(xLu(i,j):xRl(i,j),yLu(i,j):yRl(i,j));
        % center in the local image to find the threshold level. 
        Iinitial = Ilocal(pixOff:end-pixOff, pixOff:end-pixOff);
        mFull = bitRange/max(Iinitial(:));
        Iinitial = Iinitial * mFull;
        [thr, eff] = graythresh(Iinitial);
        % apply threshold to ythe full local image
        outSeg(i,j).binSpot  = im2bw(mFull * Ilocal, thr);
        outSeg(i,j).thrEff  = eff;
    end
end




