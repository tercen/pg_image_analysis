function [iOut, wMean, wStd] = RWoutlierDetection(x, p)
% function [iOut, wMean, wStd] = RWoutlierDetection(x,p)
% Detects outliers on a vector of data x at significance level p
% Assumes that the clean x is normally distributed.
% p [0:1], equals the probability that detected outliers are NOT outliers but genuinly 
% arising form the distribution of x
% OUT:
% iOut, logical array of size(x) TRUE if the corresponding element of x is
% an outlier
% wMean: robust weighted mean of x
% wStd: robust weighted std of x
% The routine uses a Tukey biweight to calculate wMean and wStd
% Outliers are assigned using a t-test using t = (data-wMean)/wStd

data = reshape(x, numel(x),1); % single vector

% calculate biweights
K = 4.65;
s = 0.6745;

robVar = median(abs(data-median(data)))/s;
wRes = (data - median(data) )/(K*robVar);
wRob = zeros(size(wRes));
iNonZero = abs(wRes) < 1;
wRob(iNonZero) = ( 1 - wRes(iNonZero).^2).^2;

% calculate weighted mean
wMean = mean(data.*wRob);
% calculate weighted standard deviation
n = length(data);
wStd = sqrt( (1/(n-1)) * sum( wRob.*(data - wMean).^2));
t = abs((x - wMean)/wStd);
tCrit = qt(1 -(p/2), length(data));
iOut = t > tCrit;
%EOF