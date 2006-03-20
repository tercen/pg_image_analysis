function [quantitationTypes, confidenceTypes] = calQuantitationTypes(xData, yData)
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

modelID = getModelID();
x = double(xData);
y = double(yData);

if size(x,2) > size(x,1)
    x = x';
end
if size(y,2) > size(y,1)
    y = y';
end


% check if parameter set, otherwise refer to defaults

pdef = getParameterDefinition();
for i=1:length(pdef)
    
    if eval(['isempty(',pdef(i).name,')'])
        eval([pdef(i).name, '=', num2str(pdef(i).dft),';'])
    end
end

% set enumerated mappings
[val, map] = getpropenumeration('fitMode');
strFitMode = char(map(find(fitMode == val)));
[val, map] = getpropenumeration('errorMode');
strErrorMode = char(map(find(errorMode == val)));
[val, map] = getpropenumeration('xToleranceMode');
strTolMode = char(map(find(xToleranceMode == val)));


if ~isnumeric(xScale) |length(xScale) > 1
    error('Invalid value for xScale');
end
if xScale < 0
    error('Invalid value for xScale');
end

if xScale == 0
    xIn = x;
else
    xScale = double(xScale);
    xIn = xScale.^(x);
end

% initialize the fit model
oP = pgFit(modelID);
% get auto values for iniPars
oF = get(oP, 'modelObj');
p  = getInitialParameters(oF,x, y);
pIni    = [Y0_initial, Ymax_initial, logIC50_initial, hs_initial]';
pOver   = [Y0_auto, Ymax_auto, logIC50_auto, hs_auto]';
pLower  = [Y0_lower, Ymax_lower, logIC50_lower, hs_lower]';
pUpper =  [Y0_upper, Ymax_upper, logIC50_upper, hs_upper]';
% if pOver, override user input with auto values 
%and set other parameters
pOver = logical(pOver);
pIni(pOver) = p(pOver);
oP = set(oP, 'lbPars', pLower, 'ubPars', pUpper, 'iniPars', pIni, ...
               'errorMethod', strErrorMode, ...
               'TolMode', strTolMode, ...
               'fitMethod', strFitMode, ...
               'TolX', xTolerance, ...
               'robTune', robTune, ...
               'maxIterations', maxIterations);

xOffset = 0;
[pOut,pStdError, wOut] = computeFit(oP, xIn - xOffset,y);
f = getCurve(oF, xIn - xOffset, pOut);
R2 = corrcoef(f,y); R2 = R2(2,1);
aChiSqr = sum( (f-y).^2);
iOut = y == 0;
rChiSqr = sum( ( f(~iOut)-y(~iOut) )./y(~iOut).^2) ;







quantitationTypes = [pOut;
                     pStdError;
                     R2;
                     aChiSqr;
                    rChiSqr;
                    ];
      
confidenceTypes = wOut;
