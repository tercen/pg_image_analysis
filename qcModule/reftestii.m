% RefTest
clear all
close all
v = vLoad('D:\temp\data\040818-M040630A-MW-C6 Q-results\F1\T20\Median\todat.v');
disp('Select Normalizers ...');
clRefID = vPick(v, 'ID');
maps   = vArrange96(v, 'ID', clRefID, 'EndLevel');
mRefs  = vArrange96(v, 'ID', clRefID, 'EndLevel', 'Average');
[s1,s2,s3] = size(maps);
refcols = reshape(maps,s1*s2, s3)
for i=1:s3
    mMaps(:,:,i) = maps(:,:,i)/mean(refcols(:,i));
end
refcols = reshape(mMaps, s1*s2*s3, 1);
iOut = findOutliersRW(refcols, 3, 0.01);

figure(1)
subplot(2,1,1)
plot(refcols)
hold on
plot(find(iOut), refcols(find(iOut)),'ro')
subplot(2,2,3)
[cnts,x] = hist(refcols, 15)
h = bar(x, cnts);
set(h, 'FaceColor', 'g')
hold on
cnts = hist(refcols(find(iOut)), x);
h = bar(x, cnts);
set(h, 'FaceColor', 'r');
% meanR = mean(refcols);
% robVar = median(abs(refcols-meanR))/0.6745;
% wRes = abs(refcols-meanR)/(3*robVar);
% iIn = find(wRes <= 1);
% refIn = refcols(iIn)  
% figure(1)
% subplot(2,1,1)
% plot(refcols)
% hold on
% plot(iIn, refcols(iIn) ,'r.')
% subplot(2,1,2)
% plot(wRes)
% figure(2)
% subplot(2,2,1)
% plot(mRefs, '.-')
% subplot(2,2,2)
% plot(mRefs', '.-')

