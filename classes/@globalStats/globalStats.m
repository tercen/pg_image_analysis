function g = globalStats(argin)
if nargin == 0
    g.odSigmaFac = 3;
    g.odEpsilon = 0.01;
    g.bLocalT = 1;
    g.bLocalCV = 1;
    g.bGlobalMetrics = 1;
    
    g = class(g, 'globalStats');
    
elseif isa(argin, 'globalStats')
        g = argin;
else
        error(['Cannot create a globalStats object from object of class: ',class(argin)]);
end
    