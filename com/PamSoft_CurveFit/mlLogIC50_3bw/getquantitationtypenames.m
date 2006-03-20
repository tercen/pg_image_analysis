function qNames = getQuantitationTypeNames()
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global Y0_initial
global Y0_auto
global Ymax_initial
global Ymax_auto
global logIC50_initial
global logIC50_auto

qNames = {'Y0', 'Ymax', 'logIC50', 'Y0 standard error', 'Ymax standard error', 'logIC50 standard error', 'R2', 'absolute ChiSqr', 'relative ChiSqr'};

qNames = qNames';