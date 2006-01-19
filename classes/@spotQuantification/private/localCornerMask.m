function iMask = localCornerMask(mSize)
%
bgOffset = 0.45;

lcMask = false(mSize);
spotPitch = mSize(1)/2;
% midpoint centered coordinates of mask
[x, y] = find(~lcMask);
cc  = [x, y] - repmat(size(lcMask)/2,numel(lcMask),1);
% find coordinates that are in square of +/- 0.5 spotPitch
inSquare =  cc(:,1) >= -bgOffset*spotPitch & cc(:,1) <= bgOffset*spotPitch &  ...
            cc(:,2) >= -bgOffset*spotPitch & cc(:,2) <= bgOffset*spotPitch;
        
inCircle = cc(:,1).^2 + cc(:,2).^2 <= (bgOffset*spotPitch)^2;
iMask = uint16(find(inSquare & ~inCircle));


