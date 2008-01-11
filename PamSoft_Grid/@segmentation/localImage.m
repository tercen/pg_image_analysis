function Ilocal = localImage(s, I)
% extracts local spot image from main image
cLu = s.bsLuIndex;

i = cLu(1):cLu(1) + s.bsSize(1) - 1;
j = cLu(2):cLu(2) + s.bsSize(2) - 1;
Ilocal = I(round(i), round(j));
