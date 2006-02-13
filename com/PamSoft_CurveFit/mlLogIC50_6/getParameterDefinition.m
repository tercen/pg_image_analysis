function pdef = getParameterDefinition()
% global xScale
% global fitMode
% global robTune
% global errorMode
% global xTolerance
% global xToleranceMode
% global maxIterations
% global Y0_initial
% global Y0_auto
% global Y0_lower
% global Y0_upper
% global Ymax_initial
% global Ymax_auto
% global Ymax_lower
% global Ymax_upper
% global logIC50_initial
% global logIC50_auto
% global logIC50_lower
% global logIC50_upper
% global hs_initial
% global hs_auto
% global hs_lower
% global hs_upper

%
pdef(1).name    = 'xScale';
pdef(1).dft     = 0;
pdef(1).enumVal = [];
pdef(1).enumMap = '';

pdef(2).name    = 'fitMode';
pdef(2).dft     = uint8(0);
pdef(2).enumVal = uint8([0,1,2,3]);
pdef(2).enumMap = {'Normal', 'Robust', 'Robust2', 'Filter'};

pdef(3).name    = 'robTune';
pdef(3).dft     = 1;

pdef(4).name    = 'errorMode';
pdef(4).dft     = uint8(0);
pdef(4).enumVal = 0;
pdef(4).enumMap = {'ASE'};

pdef(5).name    = 'xToleranceMode';
pdef(5).dft     = 0;
pdef(5).enumVal = uint8([0,1]);
pdef(5).enumMap = {'Relative', 'Absolute'};

pdef(6).name    = 'maxIterations';
pdef(6).dft     = 20;

pdef(7).name    = 'xTolerance';
pdef(7).dft     = 0.01;

pdef(8).name   = 'logIC50_initial';
pdef(8).dft    = -8;

pdef(9).name   = 'logIC50_auto';
pdef(9).dft    = uint8(1);
pdef(9).enumVal = uint8([0,1]);
pdef(9).enumMap = {'no', 'yes'};

pdef(10).name   = 'logIC50_lower';
pdef(10).dft    = -100;

pdef(11).name   = 'logIC50_upper';
pdef(11).dft  = -1e-7;

