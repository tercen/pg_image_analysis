function mOut = findOutliersRW(data, maxSigmaFactor, eps)
sData = size(data);
meanData    = mean(data)
medianData  = median(data);
K = 4.65;
mOut = zeros(size(data));
for i=1:sData(2)
    M = abs(meanData(i)-medianData(i))/meanData(i)
    while(1)
        robVar = median(abs(data(:,i) - medianData(i) ))/0.6745;
        wRes =  ((data(:,i) - medianData(i)))/(K*robVar);
        wRob = zeros(size(wRes));
        iNonZero = find(wRes<1);
        wRob(iNonZero) = ( 1 - wRes(iNonZero).^2).^2;
        wSigma = weightedDeviation(data(:,i), medianData(i), wRob);
        iOut = find( abs(data(:,i)-medianData(i)) > maxSigmaFactor * wSigma);
        mOut(iOut, i) = 1;
        meanData(i)     = mean  (data(find(~mOut(:,i))  ,i));
        medianData(i)   = median(data(find(~mOut(:,i))  ,i));
        
        M = abs(meanData(i)-medianData(i))/meanData(i)
        if (M < eps)
            break;
        end
    end
end
