function dftValue = getDftParameter(parName);
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations

switch parName 
    case 'xScale'
        dftValue = 0.0;
    case 'fitMode'
        dftValue = uint8(0);
    case 'robTune'
        dftValue = 1.0;
    case 'errorMode'
        dftValue = uint8(0);
    case 'xTolerance'
        dftValue = 0.01;
    case 'xToleranceMode'
        dftValue = uint8(0);
    case 'maxIterations'
        dftValue = 20;
    otherwise
        dftValue = [];
end

