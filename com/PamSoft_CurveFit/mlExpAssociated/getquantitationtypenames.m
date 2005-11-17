function qNames = getQuantitationTypeNames()
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global xOffset
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Yspan_initial
global Yspan_auto
global Yspan_lower
global Yspan_upper
global k_initial
global k_auto
global k_lower
global k_upper
qNames = {'Y0', 'Yspan', 'k', 'Y0 standard error', 'Yspan standard error', 'k standard error', 'R2', 'absolute ChiSqr', 'relative ChiSqr'};

qNames = qNames';