function [iOut, limits] = iqrDetection(data, measure)
% calculate iqr
iqrLimits = quantile(data, [0.25, 0.75]);
iqr = iqrLimits(2) - iqrLimits(1);
limits(1) = iqrLimits(1) - measure *iqr;
limits(2) = iqrLimits(2) + measure *iqr;
iOut = data < limits(1) | data > limits(2);
%EOF

