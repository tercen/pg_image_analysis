function template = makeTemplate(g, imageSize)
% function Template = makeTemplate(g, imageSize)
refMask          = g.mask;
spotPitch        = g.spotPitch;
spotDiameter     = g.spotSize;
axRot            = g.rotation;

mp = round(imageSize)/2;

nSpots = length(find(refMask));

spotRad = round(spotDiameter/2);
se = strel('disk', spotRad);
spot = uint8(getnhood(se));
[s1, s2] = size(spot);
template = uint8(zeros(imageSize(1), imageSize(2), length(axRot)));
for iRot=1:length(axRot)
    [x,y] = gridCoordinates(mp, refMask, spotPitch, axRot(iRot));
    xyLu = [round(x),round(y)] - repmat(round([s1,s2]/2), nSpots,1);
    xyRl = xyLu  + repmat([s1,s2] - 1, nSpots,1);

    if any(xyLu < 1) | any(xyRl(:,1) > imageSize(1)) | any(xyRl(:,2) > imageSize(2))
        error('Array out of image');
    end

    for i=1:nSpots
        iX1 = xyLu(i,1);
        iX2 = xyRl(i,1);
        iY1 = xyLu(i,2);
        iY2 = xyRl(i,2);
        template(iX1:iX2, iY1:iY2, iRot) = spot;
    end
end
template = 255 * template;
%EOF