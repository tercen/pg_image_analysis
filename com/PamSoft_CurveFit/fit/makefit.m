function [pOut, pStdError, wOut]  = makefit(x,y, modelID, pIni, pOver, pLower, pUpper)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations

x = double(x);
y = double(y);

if isempty(xScale)
    xScale = getDftParameter('xScale');
end
if ~isnumeric(xScale) |length(xScale) > 1
    error('Invalid value for xScale');
end
if xScale < 0
    error('Invalid value for xScale');
end

if xScale == 0
    xIn = x;
else
    xScale = double(xScale);
    xIn = xScale.^(x);
end
if isempty(robTune)
    robTune = getDftParameter('robTune');
end

if isempty(xTolerance)
    xTolerance = getDftParameter('xTolerance');
end
if isempty(maxIterations)
    maxIterations = getDftParameter('maxIterations');
end
if isempty(fitMode)
    fitMode = getDftParameter('fitMode');
end
if isempty(errorMode)
    errorMode = getDftParameter('errorMode');
end
if isempty(xToleranceMode)
    xToleranceMode = getDftParameter('xToleranceMode');
end

% set enumerated parameters
[val, map] = getEnumeration('fitMode');
strFitMode = char(map(find(fitMode == val)));
[val, map] = getEnumeration('errorMode');
strErrorMode = char(map(find(errorMode == val)));
[val, map] = getEnumeration('xToleranceMode');
strTolMode = char(map(find(xToleranceMode == val)));

% initialize the fit model
oP = pgFit(modelID);
% get auto values for iniPars
oF = get(oP, 'modelObj');
p  = getInitialParameters(oF,x, y);
% if pOver, override user input with auto values 
% and set other parameters
pIni(pOver) = p(pOver);
oP = set(oP, 'lbPars', pLower, 'ubPars', pUpper, 'iniPars', pIni, ...
               'errorMethod', strErrorMode, ...
               'TolMode', strTolMode, ...
               'fitMethod', strFitMode, ...
               'TolX', xTolerance, ...
               'robTune', robTune, ...
               'maxIterations', maxIterations);
           
[pOut,pStdError, wOut] = computeFit(oP, xIn,y);