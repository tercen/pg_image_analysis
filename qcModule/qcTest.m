clear all 
close all
vFile = 'D:\temp\data\040818-M040630A-MW-C6 Q-results\F1\T20\Median\todat.v';
v = vLoad(vFile);
disp('pick your spots ...')
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
iIn = find(R2 > 0.5);


rChi = aChiSqr(iIn)./Vini(iIn);
mrChi = mean(rChi);
robVar = median(median(abs(rChi-mrChi)))/0.6745;
wRes = abs(rChi - mrChi)./(3*robVar);
iIn = find(wRes<1);
figure(1)
hist(rChi(iIn),25);
figure(2)
subplot(2,1,1)
semilogy(rChi)
hold on
semilogy(iIn, rChi(iIn), 'r.')

subplot(2,1,2)
plot(wRes,'.')