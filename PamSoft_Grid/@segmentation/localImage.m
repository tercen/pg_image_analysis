function Ilocal = localImage(s, I)
% extracts local spot image from main image

cLu = s.bsLuIndex;
i = round(cLu(1):cLu(1) + s.bsSize(1) - 1);
j = round(cLu(2):cLu(2) + s.bsSize(2) - 1);
iUse = i > 0 & i <= size(I,1);
jUse = j > 0 & j <= size(I,2);
if any(~iUse)||any(~jUse)
    error('Spot detection out of image frame');
end
Ilocal = I(i(iUse), j(jUse));
