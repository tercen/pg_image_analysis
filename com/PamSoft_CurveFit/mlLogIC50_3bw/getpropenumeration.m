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
global Ymax_initial
global Ymax_auto
global logIC50_initial
global logIC50_auto

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
 
        
