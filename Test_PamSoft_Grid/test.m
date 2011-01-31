clear all
global grdSpotPitch
global qntSeriesMode
global qntShowPamGridViewer
global grdSearchDiameter
global grdUseImage
global segEdgeSensitivity
global sqcMaxPositionOffset;
global segAreaSize;
global sqcMinSnr;
global sqcMinDiameter

sqcMinDiameter = 0.45;
segEdgeSensitivity = [0, 0.01];
qntSeriesMode = 0;
qntShowPamGridViewer = 1;
grdSpotPitch = 21.7;
grdUseImage = -3;
dDir = 'D:\A_PG_Data\Rik\ImageSpotGrid2';

%% load images from cycle 93 with varying exposure time
flist = dir([dDir, '\*.tif']);
for i=1:length(flist)
    flist(i).fullName = fullfile(dDir,flist(i).name);
end
grdfromfile('D:\A_PG_Data\Rik\ImageSpotGrid2\631044601 86311 Array Layout.txt', '#')
[names{1:length(flist)}] = deal(flist.fullName);

qt = analyzecycleseries(names);

