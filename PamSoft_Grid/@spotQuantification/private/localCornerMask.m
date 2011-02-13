function iMask = localCornerMask(q)
%
bgOffset = 0.45;
oS = get(q, 'oSegmentation');
oS = oS{:};
segMethod = get(oS, 'method');
switch segMethod
    case 'Edge'
        iMask = maskFromEdgeSegmentation(oS, bgOffset);
    otherwise
        error('segmentation method not supported');
end

function iMask = maskFromEdgeSegmentation(oS, bgOffset)

spotPitch = get(oS, 'spotPitch');
mSize = get(oS, 'bsSize');
lcMask = false(mSize);
%lmp = localMidpoint(oS);
lmp = get(oS, 'finalMidpoint');
% midpoint centered coordinates of mask
[x, y] = find(~lcMask);
cc  = [x, y] - repmat(lmp,numel(lcMask),1);
% find coordinates that are in square of +/- 0.5 spotPitch
inSquare =  cc(:,1) >= -bgOffset*spotPitch & cc(:,1) <= bgOffset*spotPitch &  ...             
    cc(:,2) >= -bgOffset*spotPitch & cc(:,2) <= bgOffset*spotPitch;
%       
inCircle = cc(:,1).^2 + cc(:,2).^2 <= (bgOffset*spotPitch)^2;
lcMask(inSquare&~inCircle) = true;
iMask = find(lcMask);


