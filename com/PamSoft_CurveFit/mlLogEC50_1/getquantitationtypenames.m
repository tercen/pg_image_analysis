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
global Y0_lower
global Y0_upper
global Ymax_initial
global Ymax_auto
global Ymax_lower
global Ymax_upper
global logEC50_initial
global logEC50_auto
global logEC50_lower
global logEC50_upper
global hs_initial
global hs_auto
global hs_lower
global hs_upper

qNames = {'Y0', 'Ymax', 'logIC50','hs', 'Y0 standard error', 'Ymax standard error', 'logIC50 standard error','hs standard error', 'R2', 'absolute ChiSqr', 'relative ChiSqr'};

qNames = qNames';