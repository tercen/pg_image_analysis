function dftValue = getPropDefault(parName);
global outlierMethod
global outlierMeasure

pdef = getProperties();
[pnames{1:length(pdef)}] = deal(pdef.name);
iMatch = strmatch(parName, pnames, 'exact');
if ~isempty(iMatch)
    dftValue = pdef(iMatch).dft;
else
    dftValue = [];
end


