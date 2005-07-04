function oP = rescale(oP, rFactor)
oP.nSmallDisk = max(round(oP.nSmallDisk * rFactor),1);
oP.nLargeDisk = max(round(oP.nLargeDisk * rFactor),1);
oP.nCircle = max(round(oP.nCircle * rFactor),1);
oP.nBlurr = max(round(oP.nBlurr * rFactor),1);