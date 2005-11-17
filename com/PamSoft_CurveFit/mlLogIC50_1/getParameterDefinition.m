function pdef = getParameterDefinition()
% global xScale
% global fitMode
% global robTune
% global errorMode
% global xTolerance
% global xToleranceMode
% global maxIterations


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

pdef(8).name   = 'xOffset';
pdef(8).dft     = 0.0;

pdef(9).name    = 'Y0_initial';
pdef(9).dft     = 0;

pdef(10).name       = 'Y0_auto';
pdef(10).dft        = uint8(1);
pdef(10).enumVal    = uint8([0,1]);
pdef(10).enumMap    = {'no', 'yes'};

pdef(11).name       = 'Y0_lower';
pdef(11).dft        = 1e-7;

pdef(12).name       = 'Y0_upper';
pdef(12).dft        = 1e8;

pdef(13).name       = 'Ymax_initial';
pdef(13).dft        = 1;

pdef(14).name       = 'Ymax_auto';
pdef(14).dft        = uint8(1);
pdef(14).enumVal    = uint8([0,1]);
pdef(14).enumMap    = {'no', 'yes'};

pdef(15).name       = 'Ymax_lower';
pdef(15).dft        = -1e8;

pdef(16).name       = 'Ymax_upper';
pdef(16).dft        = 1e8;

pdef(17).name       = 'logIC50_initial';
pdef(17).dft        = -5;

pdef(18).name       = 'logIC50_auto';
pdef(18).dft        = uint8(1);
pdef(18).enumVal    = uint8([0,1]);
pdef(18).enumMap    = {'no', 'yes'};

pdef(19).name       = 'logIC50_lower';
pdef(19).dft        = -100;

pdef(20).name       = 'logIC50_upper';
pdef(20).dft        = -1e-7;

pdef(21).name       = 'hs_initial';
pdef(21).dft        = -1;

pdef(22).name       = 'hs_auto';
pdef(22).dft        = uint8(1);
pdef(22).enumVal    = uint8([0,1]);
pdef(22).enumMap    = {'no', 'yes'};

pdef(23).name       = 'hs_lower';
pdef(23).dft        = -100;

pdef(24).name       = 'hs_upper';
pdef(24).dft        = -1e-7;


