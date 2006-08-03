function [mpOut, rotOut, spOut, xFit, yFit] = fit(oArray, xPos, yPos)

mp(1) = mean(xPos(:));
mp(2) = mean(yPos(:));

fmask = ones(size(oArray.mask));
if isempty(oArray.xOffset)
    xOff = zeros(size(fmask));
end
if isempty(oArray.yOffset)
    yOff = zeros(size(fmask));
end

% call lsq fit with @arrayFitFunction to get mp and rotation in p
pIn  = [mp(1), mp(2), 0, oArray.spotPitch];
pLower = [-1000,-1000,-5,-1000];
pUpper = [1000,1000, 5, 1000];
opt = optimset('Display', 'off', 'MaxFunEvals', 200, 'TolFun', 0.05);
pOut = lsqnonlin(@arrayFitFunction, pIn, pLower, pUpper, opt,oArray, xPos, yPos);
mpOut = pOut(1:2);
rotOut = pOut(3);
spOut = pOut(4);
[xFit, yFit] = coordinates(oArray, mpOut, rotOut);

