function [models, nModels] = getavailablemodels()
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
f = fitFunction();
clModels = getAvailableModelList(f);
nModels = length(clModels);
models = [clModels{1}];
for i=2:nModels
    models = [models, '_', clModels{i}];
end
