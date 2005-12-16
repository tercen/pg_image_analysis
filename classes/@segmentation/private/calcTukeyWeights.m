function wRob = calcTukeyWeights(res,tune)
% wRob = calcTukeyWeight(res, tune)
if nargin < 2
    tune = 1;
end
K = tune*4.685;
mad = median(abs(res));
robVar = mad/0.6745;
%
wResAdjusted = res/(K*robVar);
wRob = (abs(wResAdjusted) < 1) .* (1-wResAdjusted.^2).^2; 