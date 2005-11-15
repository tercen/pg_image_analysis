function dftVal = getDftParameter(parName)
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

oF = fitFunction('logIC50_1');

[pIni, pLower, pUpper] = getInitialParameters(oF, [1:3]', [1:3]'); 
switch parName
    case 'Y0' 
        dftVal = 0.0;
    case 'Y0_lower'
        dftVal = pLower(1);
    case 'Y0_upper'
        dftVal = pUpper(1);
    case 'Ymax'
        dftVal = 1.0;
    case 'Ymax_lower'
        dftVal = pLower(2);
    case 'Ymax_upper'
        dftVal = pUpper(2);
    case 'logIC50_1'
        dftVal = -6;
    case 'logIC50_lower'
        dftVal = pLower(3);
    case 'logIC50_upper'
        dftVal = pUpper(3);
    case 'hs'
        dftVal = -1
    case 'hs_lower'
        dftVal = pLower(4);
    case 'hs_upper' 
        dftVal = pUpper(4);
    otherwise
        dftVal = [];
end

        