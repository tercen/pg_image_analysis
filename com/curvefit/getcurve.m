function f = getcurve(x, par)
global model
global xScale
global fitMode
global robTune
global errorMode
global parInitialGuess
global parLowerBounds
global parUpperBounds
global xTolerance
global xToleranceMode
global jacobian
global maxIterations

x = double(x);
par = double(par);

if ~isnumeric(xScale) |length(xScale) > 1
    error('Invalid value for xScale');
end

if xScale < 0
    error('Invalid value for xScale');
end

if isempty(xScale)
    xScale = 0;
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

oF = fitFunction(model);
f = getCurve(oF, xIn, par);
if (bTranspose)
    f = f';
end
