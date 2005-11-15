function [val, map] = getEnumeration(parName)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations

switch parName
    case 'fitMode'
        val = uint8([0,1,2,3]);
        map = {'Normal', 'Robust', 'Robust2', 'Filter'};
   
    case 'errorMode'
        val = uint8(0);
        map = {'ASE'};
    case 'xToleranceMode'
        val = uint8([0,1]);
        map = {'Relative', 'Absolute'};
    otherwise
        val = [];
        map = '';
end

 
        
