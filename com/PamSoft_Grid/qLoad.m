function qLoad(filePath)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
global prpResize
global grdMask
global grdRotation
global grdSpotPitch
global grdXOffset
global grdYOffset
global grdRotation
global grdUseImage
global segMethod
global segEdgeSesitivity
global segAreaSize
global sqcMaxDiameter
global sqcMinDiameter
global sqcMinFormFactor
global sqcMaxAspectRatio
global sqcMaxPositionOffset
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
global prpResize
global grdMask
global grdRotation
global grdSpotPitch
global grdXOffset
global grdYOffset
global grdUseImage
global segMethod
global segEdgeSesitivity
global segAreaSize
global sqcMaxDiameter
global sqcMinDiameter
global sqcMinFormFactor
global sqcMaxAspectRatio
global sqcMaxPositionOffset
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntBackgroundMethod
global stateQuantification
global qntSeriesMode
global qntSaturationLimit
global qntBackgroundMethod
global stateQuantification

q = load(filePath, '-mat');
stateQuantification = q.stateQuantification;

%EOF