function [val, map] = getPropEnumeration(parName)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Ymax_initial
global Ymax_auto
global Ymax_lower
global Ymax_upper
global logIC50_initial
global logIC50_auto
global logIC50_lower
global logIC50_upper
global hs_initial
global hs_auto
global hs_lower
global hs_upper

pdef = getParameterDefinition();
[pnames{1:length(pdef)}] = deal(pdef.name);
iMatch = strmatch(parName, pnames, 'exact');
if ~isempty(iMatch) && ~isempty(pdef(iMatch).enumVal)
    val = pdef(iMatch).enumVal;
    map = pdef(iMatch).enumMap;
else
    val = [];
    map = '';
end
 
        
