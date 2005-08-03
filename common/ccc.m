function rc = ccc(x,y)
% function rc = ccc(x,y)
% Lin concordance correlation coefficient between data vectors x and y
% according to Zar p403.

mx = mean(x);
my = mean(y);
rc = 2 * sum(x.*y)./( sum(x.^2) + sum(y.^2) + (length(x)-1) * (mx-my).^2);
% EOF