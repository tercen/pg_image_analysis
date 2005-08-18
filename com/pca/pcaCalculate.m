function pcaCalculate
global data
global loadings
global scores
global relVariation
global idVariable
global idCondition

if isempty(data)
    error('data has not been set');
end

[loadings, scores, var] = princomp(data');
relVariation = var/sum(var);
