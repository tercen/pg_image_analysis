function [x0, y0, r] = robCircFit(x,y)

x = x(:);
y = y(:);
maxIter = 10;
eps = 0.001;

w = ones(size(y));
while(1)
    [x0, y0, r] = circfit(x,y,w);
    
    res =  ( (x- x0).^2 + (y - y0).^2 - r^2).^2
    ChiSqr = sum(res);
    w = calcTukeyWeights(res);
    


end

