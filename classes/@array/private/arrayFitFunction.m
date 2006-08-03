function D = arrayFitFunction(par, oArray, xData, yData)
m = par(1:2);
rot = par(3);
spotPitch = par(4);
[x,y] = gridCoordinates(m, ones(size(oArray.mask)),spotPitch, rot, oArray.xOffset, oArray.yOffset);
w = oArray.mask(:) ~= 0;
D = w.*sqrt(((xData(:) - x(:)).^2 + (yData(:)-y(:)).^2));
D = D/length(find(w));

