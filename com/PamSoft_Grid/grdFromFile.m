function grdfromfile(templatePath, grdRefMarker)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
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
global segMethod
global segEdgeSensitivity
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
global qntOutlierMethod
global qntOutlierMeasure
global qntShowPamGridViewer
global stateQuantification


oArray =  fromFile(array, templatePath, grdRefMarker);
qntSpotID = get(oArray, 'ID');
grdCol          = get(oArray, 'col');
grdRow          = get(oArray, 'row');
grdIsReference  = get(oArray, 'isreference');
grdXOffset = get(oArray, 'xOffset');
grdYOffset = get(oArray, 'yOffset');
grdXFixedPosition = get(oArray, 'xFixedPosition');
grdYFixedPosition = get(oArray, 'yFixedPosition');

