function qLoad(filePath)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpResize
global grdRow
global grdCol
global grdIsReference
global grdRotation
global grdSpotPitch
global grdSpotSize
global grdXOffset
global grdYOffset
global grdUseImage
global grdXFixedPosition
global grdYFixedPosition
global grdSearchDiameter
global grdOptimizeSpotPitch
global grdOptimizeRefVsSub;
global segEdgeSensitivity
global segAreaSize
global sqcMaxDiameter
global sqcMinDiameter
global sqcMaxPositionOffset
global sqcMinSignalToNoiseRatio
global sqcMinSpotAlignment
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntOutlierMethod
global qntOutlierMeasure
global qntShowPamGridViewer
global stateQuantification

q = load(filePath, '-mat');
stateQuantification = q.stateQuantification;

%EOF
