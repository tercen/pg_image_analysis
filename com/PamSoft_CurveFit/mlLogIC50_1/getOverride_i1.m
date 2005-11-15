function override = getOverride(parName)
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
    case 'Ymax' 
        override = 2;
    case 'Y0'
        override = 2;
    case 'logIC50'
        override = 2;
    case 'hs'
        override = 2;
    
    otherwise
        override = 0;
end
