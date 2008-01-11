function Ice = combineExposures(I, T, satLimit)
% find the saturated pixels
classOfImage = class(I);
bExp = I >= satLimit;
% scale the images using exposure time
% note that this neglects any CCD offset.
I = double(I);
I = I./repmat(permute(T, [2,3,1]), size(I,1), size(I,2));
% mask the saturated pixels, and get the max non saturated values in Ice
Ice = I;
Ice(bExp) = nan;
Ice = nanmax(Ice, [], 3);
% replace remaining nan entries in Ice with pixel value of lowest exposure
% in I
bNan = isnan(Ice);
[Tm, imin] = min(T);
I = I(:,:,imin);
Ice(bNan) = I(bNan);
% scale to full range, and convert to the original class
Ice = Ice/max(Ice(:));

switch classOfImage
    case 'uint8'
        Ice = uint8(Ice * (-1 + 2^8));
    case 'uint16'
        Ice = uint16(Ice * (-1 + 2^16));
end

       
