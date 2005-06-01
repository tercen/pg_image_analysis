function [R2, aX2, rX2, zRuns] = gof(yData, yFit)
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

sY = size(yData);
sF = size(yFit);
if sY ~= sF
    error('Non matching size of yData and yFit arrays')
end

[lDim, iDim] = min(sY);
if lDim ~= 1
    error('yData and yFit must be vector sized, not matrices');
end

if iDim == 1
    yData = yData';
    yFit = yFit';
end
R2 = CalcR(yFit, yData);
aX2 = sum((yFit-yData).^2);
iZero = yData == 0;
rX2 = sum(((yFit(~iZero)-yData(~iZero))./yData(~iZero)).^2);
zRuns = -1;     %runsTest(yFit-yData);

