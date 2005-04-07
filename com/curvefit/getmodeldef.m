function [modelName, modelDescription, nPar, parNames] = getmodeldef()
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

if isempty(model)
    error('No model defined');
end
f = fitFunction(model);
modelName   = get(f,'strModelName');
modelDescription = get(f, 'strModelDescription');
clNames = get(f, 'clParameter');
nPar = length(clNames);
parNames = char(clNames);

% parNames = [clNames{1}];
% for i=2:nPar
%     parNames = [parNames,'_',clNames{i}];
% end

    