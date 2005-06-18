function [x,y,oS, oQ] = gridKinetics(I, iGrid, oArray, pars, rSize, clID);

axRot = [pars.minRot:pars.dRot:pars.maxRot];
oArray = set(oArray, 'rotation', axRot);
oPP = preprocess();
oPP = set(oPP, 'nCircle',pars.nCircle, 'nLargeDisk', pars.nLargeDisk, 'nSmallDisk', pars.nSmallDisk, 'nBlurr', pars.nBlurr );

Ipp = getPrepImage(oPP, I(:,:,iGrid));
Ippr = imresize(Ipp, rSize);

rPitch = pars.spotPitch * (rSize./size(Ipp));
rSpotSize  = pars.spotSize * mean(rSize./size(Ipp));
oArray = set(oArray, 'spotPitch', rPitch, 'spotSize', rSpotSize);

[x,y,rotOut, oArray] = gridFind(oArray, histeq(Ippr));
x = x* (size(I,1)/rSize(1));
y = y* (size(I,2)/rSize(2));

oS = segmentation(Ipp, x,y, 'areaSize', pars.spotPitch + 2);

[nRows, nCols] = size(get(oArray, 'mask'));
for j =1:size(I,3)
       oQ(:,:,j) = spotQuantification(oS, I(:,:,j), x, y, 'signalPercentiles', [0,1]);
       for row = 1:nRows
           for col = 1:nCols
               oQ(row, col, j) = set(oQ(row,col,j), 'ID', clID{row,col});
           end
       end
end
   
