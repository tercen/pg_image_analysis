function y = NormalCurve(x, m, sigma)
% function y = NormalCurve(x,mean,sigma)
y = (1/( sqrt(2*pi)*sigma)) * exp(-0.5*( (x-m)/sigma).^2);