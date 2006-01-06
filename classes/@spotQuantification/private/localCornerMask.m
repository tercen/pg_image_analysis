function iMask = localCornerMask(mSize)
%
lcMask = false(mSize);
spotPitch = mSize(1)/2;
% midpoint centered coordinates of mask
[x, y] = find(~lcMask);
cc  = [x, y] - repmat(size(lcMask)/2,numel(lcMask),1);
% find coordinates that are in square of +/- 0.5 spotPitch
inSquare =  cc(:,1) >= -0.5*spotPitch & cc(:,1) <= 0.5*spotPitch &  ...
            cc(:,2) >= -0.5*spotPitch & cc(:,2) <= 0.5*spotPitch;
        
inCircle = cc(:,1).^2 + cc(:,2).^2 <= (0.5*spotPitch)^2;
iMask = uint16(find(inSquare & ~inCircle));


