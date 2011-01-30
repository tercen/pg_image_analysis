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
dDir = 'C:\Documents and Settings\rdwijn\My Documents\140-700 Bioinformatics\pamgrid\105109806_W1-images';

%% load images from cycle 93 with varying exposure time
flist = dir([dDir, '\*P93*.tif']);
for i=1:length(flist)
    flist(i).fullName = fullfile(dDir,flist(i).name);
end
grdfromfile('631044601 86311 Array Layout.txt', '#')
[names{1:length(flist)}] = deal(flist.fullName);

qt = analyzecycleseries(names);

