function [val, map] = getPropEnumeration(parName)
global outlierMethod
global outlierMeasure

pdef = getProperties();
[pnames{1:length(pdef)}] = deal(pdef.name);
iMatch = strmatch(parName, pnames, 'exact');
if ~isempty(iMatch) && ~isempty(pdef(iMatch).enumVal)
    val = pdef(iMatch).enumVal;
    map = pdef(iMatch).enumMap;
else
    val = [];
    map = '';
end
 
        
