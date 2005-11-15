function [pIni, pLower, pUpper] = getModelInitials
global Yspan
global Yspan_lower
global Yspan_upper
global Y0
global Y0_lower
global Y0_upper
global k
global k_lower
global k_upper
pIni = [Y0; Yspan; k];
pLower = [Y0_lower; Yspan_lower; k_lower];
pUpper = [Y0_upper; Yspan_upper; k_upper];
% EOF

