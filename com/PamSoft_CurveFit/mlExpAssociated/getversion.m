function version = getversion
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global xOffset
global xOffset_auto
global xVini
global xVini_auto
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
version = 'CFEXPASS_1_0_0';
% CFEXPASS_1_0_0;
% dll cvs revision: 
% 060823 (RDW)
% added getversion method
%
% sort x and y on entry of calquantitationtype method, to ensure correct
% functioning of xOffset_auto and xVini_auto setting.
%
% Changed dft for xOffset_auto and xVini_auto to zero (FALSE)
