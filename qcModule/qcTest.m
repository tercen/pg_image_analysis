clear all 
close all

vFile = 'D:\temp\data\SO-0183C3-on StandardKinase-run 15-26-09 19-Oct-2004-ImageResults\_CurveFit Results\rik.v';
v = vLoad(vFile);

disp('pick your spots ...');
clID = vPick(v, 'ID');
mapsR       = vArrange96(v, 'ID', clID, 'R2');
mapsaChiSqr  = vArrange96(v, 'ID', clID, 'aChiSqr');
mapsrChiSqr = vArrange96(v,'ID', clID, 'rChiSqr');
mapsVini    = vArrange96(v, 'ID', clID, 'Vini');
[s1,s2,s3] = size(mapsR);
R2          = reshape(mapsR, s1*s2*s3,1);
Vini        = reshape(mapsVini, s1*s2*s3,1);
aChiSqr     = reshape(mapsaChiSqr, s1*s2*s3,1);
rChiSqr     = reshape(mapsrChiSqr, s1*s2*s3,1);
Rmin = 0.5;

iIn = find(R2 > Rmin);
fVini = Vini(iIn);
rChi = aChiSqr(iIn)./fVini;
iOut = findOutliersRW(rChi, 2.5, 0.001);
figure
subplot(2,1,1)
plot(rChi)
hold on
plot(find(iOut), rChi(find(iOut)), 'r.');
% figure(1)
% subplot(2,1,1)
% plot(rChi)
% hold on
% plot(iIn, rChi(iIn), 'r.')
figure(2)
subplot(2,2,1)
[cnts, x] = hist(rChi,20);
h = bar(x, cnts);
set(h, 'FaceColor','y');
subplot(2,2,2)
cnts = hist(rChi(find(~iOut)),x);
maxChi = max( rChi(find(~iOut)));
m = mean(rChi(find(~iOut)));
wSigma = std(rChi(find(~iOut)));

h = bar(x, cnts);
set(h, 'FaceColor','y');
subplot(2,2,3)
hist(fVini, 15);
subplot(2,2,4)
hist(fVini(find(iOut)), 15);

fid = fopen('qcfile.txt','wt')
for i=1:length(v)
    if ~isempty(~strmatch(v(i).ID, clID))
        flag = '00000000';
        if v(i).R2 <= Rmin
            flag(8) = '1';
        end
        if v(i).aChiSqr/v(i).Vini >= m + 2.5*wSigma
            flag(7) = '1';
        end
        dFlag = bin2dec(flag);
        
        fprintf(fid, '%s\t%d\t%d\t%d\t%f\n', v(i).ID, v(i).Index1, v(i).Index2, dFlag, v(i).aChiSqr/v(i).Vini);
    end
end
fclose(fid);