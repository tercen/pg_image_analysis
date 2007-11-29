function qNames = getquantitationtypenames
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
global sqcMinFormFactor
global sqcMaxAspectRatio
global sqcMaxPositionOffset
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntOutlierMethod
global qntOutlierMeasure
global qntShowPamGridViewer
global stateQuantification
%Select from the available result types 
%     Mean_Signal
%     Median_Signal
%     Std_Signal
%     Min_Signal
%     Max_Signal
%     Mean_Background
%     Median_Background
%     Std_Background
%     Min_Background
%     Max_Background
%     Signal_pValue
%     Signal_Saturation
%     Fraction_Ignored
%     Diameter
%     Shape_Factor
%     Aspect_Ratio
%     nChiSqr
%     X_Position
%     Y_Position
%     X_Offset
%     Y_Offset
%     Empty_Spot
%     Bad_Spot
%     Replaced_Spot

qNames =    {   'Row', 'Column', 'Mean_SigmBg', 'Median_SigmBg','Mean_Signal', 'Median_Signal', 'Std_Signal', ...
                'Mean_Background', 'Median_Background', 'Std_Background', ...
                'Signal_pValue', 'Signal_Saturation', 'Fraction_Ignored', ...
                'Diameter', 'Shape_Factor', 'Aspect_Ratio', 'X_Position','Y_Position', ...
                'X_Offset', 'Y_Offset', 'Empty_Spot', 'Bad_Spot', 'Replaced_Spot'};
                
                
qNames = qNames';
