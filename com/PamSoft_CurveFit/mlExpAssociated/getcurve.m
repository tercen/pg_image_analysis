function f = getcurve(x, par)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global xOffset
global xOffset_auto
global xVini
global xVini_auto
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Yspan_initial
global Yspan_auto
global Yspan_lower
global Yspan_upper
global k_initial
global k_auto
global k_lower
global k_upper

modelID = getModelID;
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

if xOffset_auto
    xOffset = xIn(1);
end

f = getCurve(oF, xIn - xOffset, par);
if (bTranspose)
    f = f';
end
