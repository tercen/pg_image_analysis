%wellTest
close all
clear all
% FD10
% spotPitch = 41.7;
% spotSize =  27;
spotPitch = 17.7;
spotSize = 10;


iniSpot = spotSize/1.2;
axRot = [-2:0.25:2];

% mask = ones(16);
% mask(1:4,1) = 0;
% mask(1:4,end) = 0;
% mask(1, 1:4)  = 0;
% mask(end, 1:4) = 0;
% mask(end-3:end,1) = 0;
% mask(end-3:end,end) = 0;
% mask(1, end-3:end)= 0;
% mask(end, end-3:end)= 0;

mask = zeros(8,6);
mask(1,1) = 1;
mask(1,4) = 1;
mask(end,1) = 1;
mask(end,3) = 1;
mask(end,4) = 1;
mask(end, 6) = 1;
% 
% mask = zeros(14);
% mask(1,:) = 1;
% mask(:,1) = 1;
% mask(end,:) = 1;
% mask(:,end) = 1;

% C40
mask = zeros(12,10);
mask(end,1)     = 1;
mask(end-1,1)   = 1;
mask(end-2,1)  = 1;
mask(end,end) =1;
mask(end-1, end) = 1;
mask(end-2,end) = 1;
mask(1,3) = 1;
mask(1,end) = 1;

% % C16
% mask = zeros(8,6)
% mask(1,3) = 1;
% mask(1,6) = 1;
% mask(8,1) = 1;
% mask(8,4) = 1;
% mask(7,2) = 1;
% mask(7,5) = 1;

%mask = ones(size(mask));



disp('Searching data ... ');
dDir = 'D:\temp\data\SO-0288C40_Kinase050519RH -run 13-55';
disp('Searching data ...');
fList = filehound2(dDir, 'GridImageW*.tif');
fList2 = filehound2(dDir, '*P109*.tiff');

I = imread([fList(1).fPath, '\',fList(1).fName]);
rSize = [256, 256];
rPitch = spotPitch * (rSize./size(I));
rSpotSize  = spotSize * mean(rSize./size(I));

axRot = [-1:0.25:1];
oGrid = grid('spotSize', rSpotSize, 'spotPitch', rPitch, 'mask', mask, 'rotation', axRot);


for i=1:length(fList)
    I = imread([fList(i).fPath, '\', fList(i).fName]);
    Il = imread([fList2(i).fPath, '\', fList2(i).fName]);
    Ir = imresize(I, rSize);
    str = [num2str(i),':', num2str(length(fList))];

    
    [x,y,rotOut, oGrid] = gridFind(oGrid, histeq(Ir));
    x = x* (size(I,1)/rSize(1));
    y = y* (size(I,2)/rSize(2));
    
    oS = segmentation(I, x,y, 'areaSize', spotPitch);
    figure(1)
    
    %h1 = show(oS, I);
    %subplot(2,2,2)
    h2 = show(oS, Il, [0 60000]);
    
  
    
    
    %     imshow(Ir, [])
%     hold on
%     plot(y,x, 'yx')
%     title([str,' ',fList(i).fName], 'interpreter', 'none')
     pause
end

