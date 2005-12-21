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


% reduce image size
imxLu = max(1,xLu(1,1) - spotPitch); imyLu = max(1, yLu(1,1)-spotPitch);
imxRl = min(size(I,1), xRl(end,end) + spotPitch); imyRl = min(size(I,2), yRl(end,end) + spotPitch);
imxLu = round(imxLu); imyLu = round(imyLu);
imxRl = round(imxRl); imyRl = round(imyRl);
% apply morphological filtering if required.
if oS.nFilterDisk >= 1
    se = strel('disk', round(oS.nFilterDisk/2));
    I  = imerode(I, se);
    I  = imdilate(I, se);
end
Iedge = edge(I(imxLu:imxRl,imyLu:imyRl), 'canny', [0, 0.01]);
I = false(size(I));
I(imxLu:imxRl, imyLu:imyRl) = Iedge;

% start segmentation loop
pixAreaSize = oS.areaSize * spotPitch;
pixOff = round(max(spotPitch -0.5*pixAreaSize,0));
spotPitch = round(spotPitch);
for i  = 1:nRows
    for j = 1:nCols
        % store the results in nRows, nCols array of segmentation objects
        outSeg(i,j) = oS;
        delta = 2;
        xLocal = round(xLu(i,j) + [0, 2*spotPitch]);
        yLocal = round(yLu(i,j) + [0, 2*spotPitch]);
        % do while delta larget than sqrt(2) 
        while delta > sqrt(2)
            Ilocal = I(xLocal(1):xLocal(2),yLocal(1):yLocal(2));
            % center in the local image, keep the center part only.
            Iinitial = Ilocal(pixOff:end-pixOff, pixOff:end-pixOff);
            Ilocal = false(size(Ilocal));
            Ilocal(pixOff:end-pixOff, pixOff:end-pixOff) = Iinitial;
            
            areaMidpoint = round(size(Ilocal)/2);
            % get the cooridnates of foreground pixels
            [x,y] = find(Ilocal);
            % store the currebt area left upper
            outSeg(i,j).cLu = [xLocal(1), yLocal(1)];
            if length(x) < 6
                % when the number of foreground pixels is too low, abort
                spotFound = false;
                break;
            else
                spotFound = true;
            end
            
            % fit a circle to the foreground pixles
            [x0, y0, r] = robCircFit(x,y);
            % calculate the difference between area midpoint and fitted midpoint 
            mpOffset = [x0, y0]- areaMidpoint;
            delta = norm(mpOffset);        
         
            % shift area according to mpOffset for next iteration,
            % the loop terminates if delta converges to a low value.
            xLocal = round(xLocal + mpOffset(1));
            yLocal = round(yLocal + mpOffset(2));    
        end
       
        if spotFound
            outSeg(i,j).binSpot = Ilocal;
            outSeg(i,j).methodOutput.spotMidpoint = [x0, y0];
            outSeg(i,j).methodOutput.spotRadius = r;
            
        else
            outSeg(i,j).binSpot = false(size(Ilocal));
            outSeg(i,j).methodOutput = []; 
        end
    end
end




