function [val, map] = getEnumeration(parName)
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

switch parName
    otherwise
        val = [];
        map = '';
end

