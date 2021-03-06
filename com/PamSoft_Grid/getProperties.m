function pdef = getProperties
% global prpContrast
% global prpLargeDisk
% global prpSmallDisk
% global prpCircleDiameter
% global prpCircleBlurr
% global prpResize
% global grdRow
% global grdCol
% global grdIsReference
% global grdRotation
% global grdSpotPitch
% global grdSpotSize
% global grdXPosition
% global grdYPosition
% global grdXOffset
% global grdYOffset
% global grdUseImage
% global grdXFixedPosition
% global grdYFixedPosition
% global grdSearchDiameter
% global segMethod
% global segEdgeSensitivity
% global segAreaSize
% global sqcMaxDiameter
% global sqcMinDiameter
% global sqcMinFormFactor
% global sqcMaxAspectRatio
% global sqcMaxPositionOffset
% global qntSpotID
% global qntSeriesMode
% global qntSaturationLimit
% global qntBackgroundMethod
% global qntOutlierMethod
% global qntOutlierMeasure
% global qntShowPamGridViewer
% global stateQuantification


%
pdef(1).name    = 'prpContrast';
pdef(1).dft     = uint8(0);
pdef(1).enumVal = uint8([0,1,2]);
pdef(1).enumMap = {'co-equalize', 'equalize', 'linear'};
%
pdef(2).name    = 'prpLargeDisk';
pdef(2).dft     = 0.51;
pdef(2).enumVal = [];
pdef(2).enumMap = [];
%
pdef(3).name    = 'prpSmallDisk';
pdef(3).dft     = 0.17;
pdef(3).enumVal = [];
pdef(3).enumMap = [];
%
pdef(end+1).name = 'prpResize';
pdef(end).dft   = [256,256];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdRow';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdCol';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdIsReference';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];

pdef(end+1).name = 'grdRotation';
pdef(end).dft   = [-2:0.25:2];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdSpotPitch';
pdef(end).dft   = 17.7;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdSpotSize';
pdef(end).dft   = 0.66;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdSearchDiameter';
pdef(end).dft   = 5;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdXOffset';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdYOffset';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdXFixedPosition';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdYFixedPosition';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'grdUseImage';
pdef(end).dft   = int8(-1);
pdef(end).enumVal = int8([-2,-1,0]);
pdef(end).enumMap = {'First then Last', 'Last', 'First'};
%
pdef(end+1).name = 'grdOptimizeSpotPitch';
pdef(end).dft = uint8(1);
pdef(end).enumVal = uint8([0,1]);
pdef(end).enumMap = {'no', 'yes'};
%
pdef(end+1).name = 'grdOptimizeRefVsSub';
pdef(end).dft = uint8(1);
pdef(end).enumVal = uint8([0,1]);
pdef(end).enumMap = {'no', 'yes'};



% pdef(end+1).name = 'segMethod';
% pdef(end).dft   = uint8(1);
% pdef(end).enumVal = int8([0,1]);
% pdef(end).enumMap = {'Threshold', 'Edge'};
%
pdef(end+1).name = 'segEdgeSensitivity';
pdef(end).dft   = [0, 0.01];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'segAreaSize';
pdef(end).dft   = 0.7;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'sqcMinDiameter';
pdef(end).dft   = 0.45;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'sqcMaxDiameter';
pdef(end).dft   = 0.85;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'sqcMinFormFactor';
pdef(end).dft   = 0.7;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'sqcMaxAspectRatio';
pdef(end).dft   = 1.4;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'sqcMaxPositionOffset';
pdef(end).dft   = 0.4;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'qntSpotID';
pdef(end).dft   = [];
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'qntSeriesMode';
pdef(end).dft   = uint8(0);
pdef(end).enumVal = uint8([0,1,2,3]);
pdef(end).enumMap = {'Fixed', 'Adapt Global', 'Adapt Local', 'Adapt All'};
%
pdef(end+1).name = 'qntSaturationLimit';
pdef(end).dft   = -1 + 2^16;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
% pdef(end+1).name = 'qntBackgroundMethod';
% pdef(end).dft   = uint8(0);
% pdef(end).enumVal = uint8([0]);
% pdef(end).enumMap = {'localCorner'};
% %
pdef(end+1).name = 'qntOutlierMethod';
pdef(end).dft   = uint8(1);
pdef(end).enumVal = uint8([0,1]);
pdef(end).enumMap = {'none', 'iqrBased'};
%
pdef(end+1).name = 'qntOutlierMeasure';
pdef(end).dft   = 1.75;
pdef(end).enumVal = [];
pdef(end).enumMap = [];
%
pdef(end+1).name = 'qntShowPamGridViewer';
pdef(end).dft = uint8(0);
pdef(end).enumVal = uint8([0,1,2]);
pdef(end).enumMap = {'No', 'Show, Wait for Close', 'Show and Continue'};



