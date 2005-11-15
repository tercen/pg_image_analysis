function [pIni, pLower, pUpper] = getModelInitials
global Y0
global Y0_lower
global Y0_upper
global Ymax
global Ymax_lower
global Ymax_upper
global logIC50
global logIC50_lower
global logIC50_upper
global hs
global hs_lower
global hs_upper
pIni    = [Y0; Ymax; logIC50; hs];
pLower  = [Y0_lower; Ymax_lower; logIC50_lower; hs_lower];
pUpper  = [Y0_upper; Ymax_upper; logIC50_upper; hs_upper];
% EOF

