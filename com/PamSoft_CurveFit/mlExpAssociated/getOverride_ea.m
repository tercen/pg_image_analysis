function override = getOverride(parName)
global Yspan
global Yspan_lower
global Yspan_upper
global Y0
global Y0_lower
global Y0_upper
global k
global k_lower
global k_upper

switch parName
    case 'Yspan' 
        override = 2;
    case 'Y0'
        override = 2;
    case 'k'
        override = 2;
    otherwise
        override = 0;
end
