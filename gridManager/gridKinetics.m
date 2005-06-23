function [x,y,oQ, oArray] = gridKinetics(I, iGrid, oArray, oPP, rSize, clID);

Ipp = getPrepImage(oPP, I(:,:,iGrid));
Ippr = imresize(Ipp, rSize);



[x,y,rotOut, oArray] = gridFind(oArray, histeq(Ippr));
x = x* (size(I,1)/rSize(1));
y = y* (size(I,2)/rSize(2));

x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

rPitch = get(oArray, 'spotPitch');
spotPitch = rPitch(1) * (size(I,1)/rSize(1));

oS = segmentation(Ipp, x,y, 'areaSize', spotPitch + 2);

[nRows, nCols] = size(get(oArray, 'mask'));
for j =1:size(I,3)
       oQ(:,:,j) = spotQuantification(oS, I(:,:,j), x, y, 'signalPercentiles', [0,1]);
       for row = 1:nRows
           for col = 1:nCols
               oQ(row, col, j) = set(oQ(row,col,j), 'ID', clID{row,col});
           end
       end
end
   
