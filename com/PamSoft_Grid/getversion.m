function version = getversion
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
global grdXPosition
global grdYPosition
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
version = 'PAMSOFT_GRID_1_0_1';
% PAMSOFT_GRID_1_0_1
% 
% binaries:
% /opt/CVS/DataAnalysis/com/PamSoft_Grid/distrib/PamSoft_Grid.ctf,v  <--  PamSoft_Grid.ctf
% new revision: 1.9; previous revision: 1.8
% 
% /opt/CVS/DataAnalysis/com/PamSoft_Grid/distrib/PamSoft_Grid_2_1.dll,v  <--  PamSoft_Grid_2_1.dll
% new revision: 1.9; previous revision: 1.8
%
% added getversion method
%
% two analysis methods:
% analyzecycleseries and analyzecycleseries_multiexposure
% The latter grids and segments on a exposure time combined image, before
% quantifying on the original images.
%
% The second output argument from the analyzecycleseries methods
% (array2index) has been removed, Instead Row and Column of the spots are
% supplied as quantitationtypes. The new methods support sparse grids
% (Tetris!) 
%
% Modified array.fromFile method (called by grdFromFile method) such that
% tab file column are identified by header. Extra columns are skipped.
% This supports adding more columns to the five required ones.


