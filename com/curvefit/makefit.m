function [pOut, wOut]  = makefit(x,y)
global model
global xScale
global fitMode
global robTune
global parInitialGuess
global parLowerBounds
global parUpperBounds
global xTolerance
global xToleranceMode
global jacobian
global maxIterations

if isempty(model)
    error('Model has not been defined');
    return
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

p = pgFit(model);
if ~isempty(fitMode)
    p = set(p, 'fitMethod', fitMode);
end
if ~isempty(robTune)
    p = set(p, 'robTune', robTune);
end
if ~isempty(parInitialGuess)
    p = set(p, 'iniPars', parInitialGuess);
end
if ~isempty(parLowerBounds)
    p = set(p, 'lbPars',parLowerBounds);
end
if ~isempty(parUpperBounds)
    p = set(p, 'ubPars', parUpperBounds);
end
if ~isempty(xTolerance)
    p = set(p, 'TolX', xTolerance);
end
if ~isempty(xToleranceMode)
    p = set(p, 'TolMode', xToleranceMode);
end
if ~isempty(jacobian)
    p = set(p, 'jacobian', jacobian);
end
if ~isempty(maxIterations)
    p = set(p, 'maxIterations', maxIterations);
end


[pOut, wOut] = computeFit(p, xIn,y);