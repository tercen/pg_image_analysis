function hBound = show(s, I)
imshow(I, []);
hold on
spots = s.spots;
[nRows, nCols] = size(spots);
hBound = [];
for i=1:nRows
    for j=1:nCols
        imHok = spots(i,j).binSpot;
        cLu = spots(i,j).cLu;
        sHok = size(imHok);
        L = bwlabel(imHok);
        mp = round(sHok/2);
        nObject = L(mp(1), mp(2));
        if nObject
            
            
            binSpot = logical(zeros(size(imHok)));
            binSpot(L == nObject) = 1;
            B = bwboundaries(binSpot);
            bound = B{1} + repmat(cLu, size(B{1},1),1) - 1;
            if spots(i,j).eps > 0.8
                hBound(i,j) = plot(bound(:,2) , bound(:,1), 'g');
            else
                hBound(i,j) = plot(bound(:,2) , bound(:,1), 'color', [0.7, 0.7,0.7]);
            end
        end
        
        end
end