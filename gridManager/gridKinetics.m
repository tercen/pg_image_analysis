function [x,y,oQ, oArray] = gridKinetics(I, Igrid, Isegment, oArray, oS, rSize, clID);

[x,y,rotOut, oArray] = gridFind(oArray, Igrid);
x = x* (size(I,1)/rSize(1));
y = y* (size(I,2)/rSize(2));

x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);

rPitch = get(oArray, 'spotPitch');
spotPitch = rPitch(1) * (size(I,1)/rSize(1));

oS = set(oS,'areaSize', spotPitch + 2);
if ~isempty(Isegment)
    % fixed gridmode if Isegment is defined
    oS = segment(oS, Isegment, x,y);
end
[nRows, nCols] = size(get(oArray, 'mask'));
for j =1:size(I,3)
       if isempty(Isegment)
           % adaptive gridMode if Isegment is not defined
           oS = segment(oS, I(:,:,j),x,y);
       end

       oQ(:,:,j) = spotQuantification(oS, I(:,:,j), x, y, 'signalPercentiles', [0,1], 'backgroundPercentiles', [0,1]);
       for row = 1:nRows
           for col = 1:nCols
               oQ(row, col, j) = set(oQ(row,col,j), 'ID', clID{row,col});
           end
       end
end
 
