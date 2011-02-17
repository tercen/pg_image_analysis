function oS = translateBackgroundMask(oS, newMidpoint, imSize)
aTranslation = newMidpoint - oS.finalMidpoint;
[bgi, bgj] = ind2sub(imSize, oS.bbTrue);
oS.bbTrue = round(sub2ind(imSize, bgi + aTranslation(1), bgj + aTranslation(2)));