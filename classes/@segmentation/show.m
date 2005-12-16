function [hImage, hBound] = show(s, I, dr)
if nargin < 3
    dr = [];
end
hImage = imshow(I, dr);
colormap(gca, 'jet');
hold on
[nRows, nCols] = size(s);
hBound = [];
for i=1:nRows
    for j=1:nCols
        B = bwboundaries(double(s(i,j).binSpot));
        cLu = s(i,j).cLu;
        bound = B{1} + repmat(double(cLu), size(B{1},1),1) - 1;
        hBound(i,j) = plot(bound(:,2) , bound(:,1), 'w');
    end
end
hold off