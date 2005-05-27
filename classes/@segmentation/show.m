function [hImage, hBound] = show(s, I, dr)
if nargin < 3
    dr = [];
end


hImage = imshow(I, dr);
colormap('jet');
hold on
spots = s.spots;
[nRows, nCols] = size(spots);
hBound = [];
for i=1:nRows
    for j=1:nCols
        B = bwboundaries(double(spots(i,j).binSpot));
        cLu = spots(i,j).cLu;
        bound = B{1} + repmat(cLu, size(B{1},1),1) - 1;
        if spots(i,j).isSpot
            hBound(i,j) = plot(bound(:,2) , bound(:,1), 'w');
        else
            hBound(i,j) = plot(bound(:,2) , bound(:,1), 'k');
        end
    end
end
hold off