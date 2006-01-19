function [hImage, hBound] = show(oQ, I, dr)
if nargin < 3
    dr = [];
end
hImage = imshow(I, dr);
hBound = [];
colormap(gca, 'jet');
szArray = size(oQ);
if ~isempty(oQ)
    hold on
    oQ = oQ(:);
    hBound = [];
    for i=1:length(oQ)
            
            cLu = get(oQ(i).oSegmentation, 'cLu');
            [x,y] = getOutline(oQ(i).oSegmentation);
            if oQ(i).isEmpty
                cStr = 'k';
            elseif oQ(i).isBad
                cStr = 'r';
            else
                cStr = 'w';
            end
            [n,m] = ind2sub(szArray,i); 
            hBound(n,m) = plot(y + cLu(2)-1, x + cLu(1)-1, cStr);
    end
     
    hold off
end