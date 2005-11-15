function der = getderivative(modelID, x, par);
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
x = double(x);
par = double(par);
f = fitFunction(modelID);
der = getDerivative(f, x, par);
% EOF
