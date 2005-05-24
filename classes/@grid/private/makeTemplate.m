function template = makeTemplate(g, imageSize)
% function Template = makeTemplate(g, imageSize)

refMask          = g.mask;
spotPitch        = g.spotPitch;
spotDiameter     = g.spotSize;
axRot            = g.rotation;

mp = round(imageSize)/2;
[x,y] = gridCoordinates(mp, refMask, spotPitch);

nSpots = length(x);

spotRad = round(spotDiameter/2);
se = strel('disk', spotRad);
spot = uint8(getnhood(se));
[s1, s2] = size(spot);

xyLu = [round(x),round(y)] - repmat(round([s1,s2]/2), nSpots,1);
xyRl = xyLu  + repmat([s1,s2] - 1, nSpots,1);

if any(xyLu < 1) | any(xyRl(:,1) > imageSize(1)) | any(xyRl(:,2) > imageSize(2))
    error('Array out of image');
    
end

template = uint8(zeros(imageSize));
for i=1:nSpots
    iX1 = xyLu(i,1);
    iX2 = xyRl(i,1);
    iY1 = xyLu(i,2);
    iY2 = xyRl(i,2);
    template(iX1:iX2, iY1:iY2) = spot;
end
template0 = immultiply(template, 255);
template = zeros(size(template0,1), size(template0,2), length(axRot));
for i=1:length(axRot)
    template(:,:,i) = imrotate(template0, axRot(i), 'crop');
end


%EOF