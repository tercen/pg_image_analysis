function f = getcurve(modelID, x, par)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations

x = double(x);
par = double(par);

if size(par,2) > size(par,1)
    par = par';
end


if ~isnumeric(xScale) |length(xScale) > 1
    error('Invalid value for xScale');
end

if xScale < 0
    error('Invalid value for xScale');
end

if isempty(xScale)
    xScale = getDftParameter('xScale');
end
if xScale == 0
    xIn = x;
else
    xScale = double(xScale);
    xIn = xScale.^(x);
end

sX = size(xIn);
bTranspose = 0;
if sX(2) > sX(1)
    xIn = xIn';
    bTranspose = 1;
end

oF = fitFunction(modelID);

f = getCurve(oF, xIn, par);
if (bTranspose)
    f = f';
end
