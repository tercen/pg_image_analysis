function aMask = getBackgroundMask(oS)
aMask = false(oS.bsSize);
aMask(oS.bbTrue) = true;