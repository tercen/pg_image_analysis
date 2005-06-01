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

mask = zeros(12);
mask(1,2) = 1;
mask(2,1) = 1;
mask(1,end-1) = 1;
mask(2, end) = 1;
mask(end,2) =1;
mask(end, end-1) = 1;



disp('Searching data ... ');
dDir = 'C:\Temp\merck\SO-0346C7-on Merck 50cyc-run 14-02-35 24-May-2005-ImageResults';
    

fList = filehound2(dDir, '*.tiff');
n = 0;
for i=1:length(fList)
    [W, F, T, P] = imgReadWFTP(fList(i).fName, [], 'PS96');
    if ~isempty(W)
        n = n+1;
        data(n).fName = fList(i).fName;
        data(n).fPath = fList(i).fPath;
        data(n).W       = char(W);
        data(n).F       = char(F);
        data(n).T       = char(T);
        data(n).P       = char(P);
    end
end
[wellList{1:length(data)}] = deal(data.W);
uWell = vGetUniqueID(data, 'W');



I = imread([data(1).fPath, '\',data(1).fName]);
rSize = [256, 256];
rPitch = spotPitch * (rSize./size(I));
rSpotSize  = spotSize * mean(rSize./size(I));

axRot = [-1:0.25:1];
oGrid = grid('spotSize', rSpotSize, 'spotPitch', rPitch, 'mask', mask, 'rotation', axRot);
oPP = preprocess();
set(oPP, 'nCircle', 380);
t = clock;
for i = 1:length(uWell);
    disp(['loading data for ', uWell{i}]); 
    iMatch = strmatch(uWell{i}, wellList);
   for j=1:length(iMatch);
       I(:,:,j) = imread([data(iMatch(j)).fPath, '\', data(iMatch(j)).fName]);
       pump  = char(data(iMatch(j)).P);
       c(j) = str2num(pump(2:end));
   end
   [c, iSort] = sort(c);
   I = I(:,:,iSort);
   disp('preprocessing ...');
   Ipp = getPrepImage(oPP, I(:,:,9));
   Ippr = imresize(Ipp, rSize);
   
   if i==1
       disp('Initializing grid finder ...')
   else
       disp('analyzing ...');
   end

   [x,y,rotOut, oGrid] = gridFind(oGrid, histeq(Ippr));
   x = x* (size(I,1)/rSize(1));
   y = y* (size(I,2)/rSize(2));
   oS = segmentation(Ipp, x,y, 'areaSize', spotPitch + 1);
   
   for j =1:size(I,3)
       oQ(:,:,j) = spotQuantification(oS, I(:,:,j), x, y, 'signalPercentiles', [0,1]);
   end
   disp('Quantification done ...')
   hp = presenter(I,x,y,oS,oQ,c);
   set(hp, 'name', uWell{i});
   pause;
   
end
etime(clock, t)
% 
% 
% for i=1:length(fList)
%     I = imread([fList(i).fPath, '\', fList(i).fName]);
%     Il = imread([fList2(i).fPath, '\', fList2(i).fName]);
%     Ir = imresize(I, rSize);
%     str = [num2str(i),':', num2str(length(fList))];
% 
%     
%     [x,y,rotOut, oGrid] = gridFind(oGrid, histeq(Ir));
%     x = x* (size(I,1)/rSize(1));
%     y = y* (size(I,2)/rSize(2));
%     
%     oS = segmentation(I, x,y, 'areaSize', spotPitch);
%     oQ = spotQuantification(oS, I, x, y, 'signalPercentiles', [0,1]);
%     disp('quantification done ...');
%     %show(oS, I);
%     
%     %p = gridPresenter('image', I, 'oQuantification', oQ, 'oSegmentation', oS , 'xGrid', x, 'yGrid', y);
%     %refresh(p);
%    
%     hp = presenter(Il,x,y,oS,oQ);
%     set(hp, 'name', fList2(i).fName);
%     pause;
%     
% end

