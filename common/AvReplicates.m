function [mx, my, stDev, N] = AvReplicates(x,y)


mx = [];
m = 0;
for i=1:length(x)
    if isempty(find(x(i) == mx))
        m = m+1;
        mx(m) = x(i);
        iReplicate = find(x(i) == x);
        my(m)       = mean(y(iReplicate));
        N(m) = length(iReplicate);
        stDev(m)    = std(y(iReplicate));
    end
end
mx = mx';
my = my';
N = N';
stDev = stDev';