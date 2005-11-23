function pdef = getParameterDefinition()
% global xScale
% global fitMode
% global robTune
% global errorMode
% global xTolerance
% global xToleranceMode
% global maxIterations
% global xOffset
% global xOffset_auto
% global xVini
% global xVini_auto
% global Y0_initial
% global Y0_auto
% global Y0_lower
% global Y0_upper
% global Yspan_initial
% global Yspan_auto
% global Yspan_lower
% global Yspan_upper
% global k_initial
% global k_auto
% global k_lower
% global k_upper

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

pdef(7).name    = 'Y0_auto';
pdef(7).dft     = uint8(1);
pdef(7).enumVal = [0,1];
pdef(7).enumMap = {'no', 'yes'};

pdef(8).name    = 'Y0_lower';
pdef(8).dft     = -1e8;

pdef(9).name    = 'Y0_upper';
pdef(9).dft     = 1e8;

pdef(10).name   = 'Yspan_initial';
pdef(10).dft    = 1;

pdef(11).name       = 'Yspan_auto';
pdef(11).dft        = uint8(1);
pdef(11).enumVal    = uint8([0,1]);
pdef(11).enumMap    = {'yes', 'no'};

pdef(12).name       = 'Yspan_lower';
pdef(12).dft        = -1e8;

pdef(13).name       = 'k_initial';
pdef(13).dft        = 0.01;

pdef(14).name       = 'k_auto';
pdef(14).dft        = uint8(1);
pdef(14).enumVal    = uint8([0,1]);
pdef(14).enumMap    = {'yes', 'no'};

pdef(15).name       = 'k_lower';
pdef(15).dft        = 1e-7;

pdef(16).name       = 'k_upper';
pdef(16).dft        = 1e8;

pdef(17).name       = 'Yspan_upper';
pdef(17).dft        = 1e8;

pdef(18).name    = 'Y0_initial';
pdef(18).dft     = 0;

pdef(19).name    = 'xTolerance';
pdef(19).dft     = 0.01;

pdef(20).name   = 'xOffset';
pdef(20).dft     = 0.0;

pdef(21).name   = 'xOffset_auto';
pdef(21).dft    = uint8(1);
pdef(21).enumVal    = uint8([0,1]);
pdef(21).enumMap = {'no', 'yes'};

pdef(22).name   = 'xVini';
pdef(22).dft    = 2.0;

pdef(23).name  = 'xVini_auto';
pdef(23).dft    = uint8(1);
pdef(23).enumVal = uint8([0,1]);
pdef(23).enumMap = {'no', 'yes'};
