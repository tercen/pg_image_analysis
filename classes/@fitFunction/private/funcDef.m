function Func = funcDef()
% this function provides a structure with an description of the available
% fitting functions

% simple IC50
Func(1).strModelName            = 'IC50 simple';
Func(1).strModelDescription     = 'Simple IC50 with offset = 0, hill slope = -1, assumes linear x-axis';

Func(1).clParameter{1}          = 'Ymax';
Func(1).clParameter{2}          = 'IC50';

Func(1).strFitFunctionName      = 'cfIC50s';
%#function cfIC50s
Func(1).strIniFunctionName      = 'ifIC50s';
%#function ifIC50s
Func(1).jacFlag                 = 0;

% IC50 with offset
Func(2).strModelName            = 'IC50 offset';
Func(2).strModelDescription     = 'IC50 with variable offset, hillslope = -1, assumes linear x-axis';

Func(2).clParameter{1}          = 'Y0';
Func(2).clParameter{2}          = 'Ymax';
Func(2).clParameter{3}          = 'IC50';

Func(2).strFitFunctionName      = 'cfIC50offset';
Func(2).strIniFunctionName      = 'ifIC50offset';
Func(2).jacFlag                 = 0;

% Exp Ass Ris
Func(3).strModelName            = 'Exp Associated';
Func(3).strModelDescription     = 'Exponential associated rise';

Func(3).clParameter{1}          = 'Y0';
Func(3).clParameter{2}          = 'Yspan';
Func(3).clParameter{3}          = 'k';

Func(3).strFitFunctionName      = 'cfExpAss';
Func(3).strIniFunctionName      = 'ifExpAss';
Func(3).jacFlag                 = 1;

% logIC50, variable slope, offset
Func(4).strModelName            = 'logIC50';
Func(4).strModelDescription     = 'logIC50, variable slope, offset, assumes log10 x-axis';

Func(4).clParameter{1}          = 'Y0';
Func(4).clParameter{2}          = 'Ymax';
Func(4).clParameter{3}          = 'logIC50';
Func(4).clParameter{4}          = 'hs';

Func(4).strFitFunctionName      = 'cfLogIC50';
Func(4).strIniFunctionName      = 'ifLogIC50';
Func(4).jacFlag                 = 0;


