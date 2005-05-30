function [signal, background, sigmbg] = getSignals(oq);

[nRows, nCols] = size(oq);
for i=1:nRows
    for j=1:nCols
        signal(i,j)         = oq(i,j).signal;
        background(i,j)     = oq(i,j).background;
        sigmbg(i,j) = signal(i,j) - background(i,j);
    end
end