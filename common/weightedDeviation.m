function wSigma = weightedDeviation(data, m, w)
sData = size(data);
wSigma = zeros(size(m));
for i=1:sData(2)
    sSqr = (1/(sData(1)-1) ) * sum(w(:,i) .* (data(:,i) - m(i)).^2);
    wSigma(i) = sqrt(sSqr);
end