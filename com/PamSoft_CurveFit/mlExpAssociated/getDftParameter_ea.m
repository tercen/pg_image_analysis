function dftVal = getDftParameter(parName)
global Yspan
global Yspan_lower
global Yspan_upper
global Y0
global Y0_lower
global Y0_upper
global k
global k_lower
global k_upper

oF = fitFunction('Exp Associated');


[pIni, pLower, pUpper] = getInitialParameters(oF, [1:3]', [1:3]'); 
switch parName
    case 'Yspan' 
        dftVal = 1.0;
    case 'Yspan_lower'
        dftVal = pLower(2);
    case 'Yspan_upper'
        dftVal = pUpper(2);
    case 'Y0'
        dftVal = 0.0;
    case 'Y0_lower'
        dftVal = pLower(1);
    case 'Y0_upper'
        dftVal = pUpper(1);
    case 'k'
        dftVal = 0.01;
    case 'k_lower'
        dftVal = pLower(3);
    case 'k_upper'
        dftVal = pUpper(3);
    otherwise
        dftVal = [];
end

        