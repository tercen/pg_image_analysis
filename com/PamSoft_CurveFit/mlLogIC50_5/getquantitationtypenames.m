function qNames = getQuantitationTypeNames()
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global logIC50_initial
global logIC50_auto
global logIC50_lower
global logIC50_upper
global hs_initial
global hs_auto
global hs_lower
global hs_upper

qNames = {'logIC50','hs', 'logIC50 standard error','hs standard error', 'R2', 'absolute ChiSqr', 'relative ChiSqr'};

qNames = qNames';