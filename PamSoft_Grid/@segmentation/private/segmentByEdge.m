function s = segmentByEdge(oS, I, cx, cy, rotation)
spotPitch = oS.spotPitch;
%  get the left upper coordinates and right lower coordinates
xLu = round(cx - spotPitch);
yLu = round(cy - spotPitch);
xRl = round(cx + spotPitch);
yRl = round(cy + spotPitch);
% make sure these are in the image
xLu(xLu < 1) = 1;
yLu(yLu < 1) = 1;
xRl(xRl > size(I,1)) = size(I,1);
yRl(yRl > size(I,2)) = size(I,2);
% resize the image for filtering
imxLu = min(xLu);
imyLu = min(yLu);
imxRl = max(xRl);
imyRl = max(yRl);
J = I(imxLu:imxRl, imyLu:imyRl);
% apply morphological filtering if required.
if oS.nFilterDisk >= 1
    se = strel('disk', round(oS.nFilterDisk/2));
    J  = imerode(J, se);
    J  = imdilate(J, se);
end
J = edge(J, 'canny', oS.edgeSensitivity);
I = false(size(I));
I(imxLu:imxRl, imyLu:imyRl) = J;
% start segmentation loop
pixAreaSize = oS.areaSize * spotPitch;
pixOff = round(max(spotPitch -0.5*pixAreaSize,0));
spotPitch = round(spotPitch);
% preallocate the array of segmentation objects
oS = setBackgroundMask(oS, size(I));
s = repmat(oS, length(cx(:)), 1);
for i=1:length(cx(:))
        s(i) = oS;
        s(i).initialMidpoint = [cx(i), cy(i)];
        delta = 2;        
        xLocal = round(xLu(i) + [0, 2*spotPitch]);
        yLocal = round(yLu(i) + [0, 2*spotPitch]); 
        % do while delta larger than sqrt(2) 
        deltaIter = 0;
        aMidpoint = s(i).initialMidpoint;
        while delta > sqrt(2) && deltaIter < 3
            deltaIter = deltaIter + 1;            
            % make sure the local coordinates are within the image
            xLocal(xLocal < 1) = 1;
            xLocal(xLocal > size(I,1)) = size(I,1);
            yLocal(yLocal < 1) = 1;
            yLocal(yLocal > size(I,2)) = size(I,2);                       
            % get the local image around the spot
            %Ilocal = false(size(I));          
            localMask = false(size(I));
            xInitial = xLocal + [pixOff,-pixOff];
            yInitial = yLocal + [pixOff,-pixOff];
            Ilocal = I(xInitial(1):xInitial(2),yInitial(1):yInitial(2));
            anObjectList = bwconncomp(Ilocal);
            nPix = cellfun(@length, anObjectList.PixelIdxList);
            [mxPix,mxObject] = max(nPix);
            s(i).bsLuIndex = [xLocal(1), yLocal(1)];
            if mxPix >= oS.minEdgePixels
                spotFound = true;
            else
                % when the number of foreground pixels is too low, abort
                spotFound = false;
                x0 = cx(i);
                y0 = cy(i);
                break;
            end
            % draw and paste the object back into original sized image
            Ilocal = false(size(Ilocal));
            Ilocal(anObjectList.PixelIdxList{mxObject}) = true;
            J = false(size(I));
            J(xInitial(1):xInitial(2),yInitial(1):yInitial(2)) = Ilocal;
            [x,y] = find(J);
            
            % fit a circle to the foreground pixels
            %[x,y] = ind2sub(size(I), anObjectList.PixelIdxList{mxObject});
            [x0, y0, r, nChiSqr] = robCircFit(x,y);
            % calculate the difference between area midpoint and fitted midpoint 
            %s(i).finalMidpoint = [x0, y0];
            mpOffset = [x0,y0] - aMidpoint;
            delta = norm(mpOffset);
            aMidpoint = [x0,y0];
            % shift area according to mpOffset for next iteration,
            % the loop terminates if delta converges to some low value.
            xLocal = round(xLocal + mpOffset(1));
            xLocal(1) = max(xLocal(1),1); xLocal(2) = max(xLocal(2),xLocal(1) + 1); 
            yLocal = round(yLocal + mpOffset(2));    
            yLocal(1) = max(yLocal(1),1); yLocal(2) = max(yLocal(2), yLocal(1) + 1);
        end
        J = false(size(I));
        if spotFound                   
            s(i).diameter = 2*r;
            s(i).chisqr = nChiSqr;            
            [xFit, yFit] = circle(x0,y0,r,round(pi*r)/2);
            J = roipoly(J, yFit, xFit);    
        end
        s(i).bsSize    = size(J);
        s(i).bsTrue    = find(J);
        s(i) = translateBackgroundMask(s(i),[x0,y0], size(I));
        s(i).finalMidpoint = [x0, y0];
end





