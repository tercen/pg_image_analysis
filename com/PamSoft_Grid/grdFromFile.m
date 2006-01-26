function grdfromfile(templatePath, grdRefMarker)
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

[oArray,qntSpotID] =  fromFile(array, templatePath, grdRefMarker);
grdMask = get(oArray, 'mask');
grdXOffset = get(oArray, 'xOffset');
grdYOffset = get(oArray, 'yOffset');
