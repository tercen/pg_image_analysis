function [v, eCode] = qcKinase(v, settingsFile, bOutput)
if nargin < 3
    bOutput = 0;
end


strFlag = '00000000';
vOut = [];
eCode = 1;
iniPars.refID = '';
iniPars.maxSigmaFacRef = 4;
iniPars.epsRef = 0.01;
iniPars.minR2Sub = 0.5;
iniPars.maxSigmaFacSub = 2.5;
iniPars.epsSub = 0.01;
iniPars.maxFractionBadRefs = 0.5;

iniPars = getparsfromfile(settingsFile, iniPars);



uniqueID    = vGetUniqueID(v, 'ID');
refID       = strmatch(iniPars.refID, uniqueID);
nSub = 0;
for i=1:length(uniqueID)
    if isempty(find(i == refID))
        nSub = nSub + 1;
        subID(nSub) = i;
    end
end
clRefID     = uniqueID(refID);
clSubID     = uniqueID(subID);
% do the ref spot statistics:
% for now put all refspots on a single large stack
refMaps = vArrange96(v, 'ID',clRefID, 'EndLevel');
[s1,s2,s3] = size(refMaps);
ref = reshape(refMaps, s1*s2,s3);
mRefAbs = mean(ref);
for i=1:s3
    ref(:,i) = ref(:,i)/mRefAbs(i);
end
ref = reshape(ref, s1*s2*s3,1);

[iOut, wSigma] = findOutliersRW(ref, iniPars.maxSigmaFacRef, iniPars.epsRef);
mRef = mean(ref(find(~iOut)));

for i=1:length(v)
    v(i).QcFlag = 0;
    iMatch = strmatch(v(i).ID, clRefID, 'exact');
    if ~isempty(iMatch)
        strFlag = '00000000';
        if abs( (v(i).EndLevel/mRefAbs(iMatch) ) - mRef) > iniPars.maxSigmaFacRef*wSigma;
            strFlag(length(strFlag))    = '1';
            strFlag(length(strFlag)-1)  = '0';
            strFlag(length(strFlag)-2)  = '1';
            v(i).QcFlag = bin2dec(strFlag);
        end
    end
end

qcMap = vArrange96(v, 'ID', clRefID, 'QcFlag', 'Average');
qcMap = qcMap/bin2dec('00000101');
[rBad, cBad] = find(qcMap >= iniPars.maxFractionBadRefs);

for j=1:length(rBad)
    for i=1:length(v)
        if ( [ rBad(j), cBad(j)] == [v(i).Index1, v(i).Index2] )
            strFlag = dec2bin(v(i).QcFlag, 8);
            strFlag(length(strFlag) -1) = '1';
            v(i).QcFlag = bin2dec(strFlag);
        end
    end
end

if (bOutput)
    figure(99)
    set(gcf, 'Name',['References: ', iniPars.refID])
    subplot(2,1,1)
    hold off
    plot(ref)
    hold on
    plot(find(iOut), ref(find(iOut)), 'r.');
    subplot(2,2,3)
    [cnts,x] = hist(ref, 15);
    h = bar(x, cnts);
    set(h, 'FaceColor', 'g');
    hold on
    cnts = hist(ref(find(iOut)),x);
    h = bar(x,cnts);
    set(h, 'FaceColor', 'r');
    subplot(2,2,4)
    imshow(imcomplement(qcMap));
    set(gca, 'Visible', 'on')
    drawnow
end



mapsR2          = vArrange96(v, 'ID', clSubID, 'R2');
mapsChiSqr      = vArrange96(v, 'ID', clSubID, 'aChiSqr');
mapsVini        = vArrange96(v, 'ID', clSubID, 'Vini');

[s1,s2,s3] = size(mapsR2);
R2      = reshape(mapsR2, s1*s2, s3);
ChiSqr  = reshape(mapsChiSqr, s1*s2, s3);
Vini    = reshape(mapsVini, s1*s2, s3);
rChi = ChiSqr./Vini;

% first filter out the kinetics with very low R2

figure(100)
set(gcf, 'Name', 'Substrates, rChi');
figure(101)
set(gcf, 'Name', 'Substrates, Vini');
for i=1:s3
    
    
    
    iIn = find(R2(:,i) > iniPars.minR2Sub);
    fVini  = Vini(iIn,i);
    fChi    = rChi(iIn,i);
    
    
    [iOut, wSubSigma(i)] = findOutliersRW(fChi, iniPars.maxSigmaFacSub, iniPars.epsSub);
    wMeanChi(i) = mean(fChi(find(~iOut)));
    if(bOutput)
        disp([char( clSubID(i)), ':', num2str(wSubSigma(i))]);
        figure(100)
        subplot(ceil(s3/2),2, i)
        hold off
        semilogy(fVini, fChi, '.')
        hold on
        semilogy(fVini(find(iOut)), fChi(find(iOut)), 'rx')
        figure(101)
        subplot(ceil(s3/2),2,i)
        hold off
        [cnts, x] = hist(fVini(find(~iOut)), 15);
        h = bar(x, cnts)
        hold on
        set(h, 'FaceColor', 'g');
        [cnts, x] = hist(fVini(find(iOut)), x);
        h = bar(x, cnts);
        title(char(clSubID(i)), 'interpreter','none');
        set(h, 'FaceColor', 'r');
    end
end


for j=1:length(v)
    strFlag = '00000000';
    iMatch = strmatch(v(j).ID, clSubID, 'exact');
    if ~isempty(iMatch)
        if v(j).R2 < iniPars.minR2Sub
            strFlag(length(strFlag)) = '1';
            strFlag(length(strFlag)-3) = '1';
        end
        if abs(v(j).aChiSqr/v(j).Vini - wMeanChi(iMatch)) > wSubSigma(iMatch)*iniPars.maxSigmaFacSub
            strFlag(length(strFlag)) = '1';
            strFlag(length(strFlag)-4) = '1';
        end
        v(j).QcFlag = bin2dec(strFlag);
    end
end

figure(102)
set(gcf, 'Name', 'Substrates: overall QC map');
qcMap = vArrange96(v, 'ID', clSubID, 'QcFlag', 'Average');
qcMap = qcMap / max(max(qcMap));
imshow(imcomplement(qcMap), 'InitialMagnification','fit')
set(gca, 'Visible', 'on');
drawnow
    
    
    
