function [hImage, hBound] = show(oQ, I, dr)
if nargin < 3
    dr = [];
end


hImage = imshow(I, dr);
hBound = [];
colormap(gca, 'jet');
if ~isempty(oQ)
    hold on

    [nRows, nCols] = size(oQ);
    hBound = [];
    for i=1:nRows
        for j=1:nCols
            B = bwboundaries(double(oQ(i,j).binSpot));
            cLu = oQ(i,j).cLu;
            bound = B{1} + repmat(cLu, size(B{1},1),1) - 1;
            if oQ(i,j).isSpot
                hBound(i,j) = plot(bound(:,2) , bound(:,1), 'w');
            else
                hBound(i,j) = plot(bound(:,2) , bound(:,1), 'k');
            end
        end
    end
    hold off
end