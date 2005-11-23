function dftValue = getPropDefault(parName);
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global xOffset
global xOffset_auto
global xVini
global xVini_auto
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Yspan_initial
global Yspan_auto
global Yspan_lower
global Yspan_upper
global k_initial
global k_auto
global k_lower
global k_upper

pdef = getParameterDefinition();
[pnames{1:length(pdef)}] = deal(pdef.name);
iMatch = strmatch(parName, pnames, 'exact');
if ~isempty(iMatch)
    dftValue = pdef(iMatch).dft;
else
    dftValue = [];
end


