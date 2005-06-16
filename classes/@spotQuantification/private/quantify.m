function oq = quantify(oq, I, cx, cy)
methodStr = oq(1,1).backgroundMethod;


switch methodStr
    case 'interleaved'
        [bgMedian, bgMean] = backgroundInterleaved(oq(1,1), I, cx, cy);
end
[nRows, nCols] = size(oq);

for i=1:nRows
    for j=1:nCols
        oq(i,j).medianBackground = bgMedian(i,j);
        oq(i,j).meanBackground   = bgMean(i,j);
        sArea = size(oq(i,j).binSpot);
        xSpot = oq(i,j).cLu(1):oq(i,j).cLu(1)+sArea(1)-1;
        ySpot = oq(i,j).cLu(2):oq(i,j).cLu(2)+sArea(2)-1;
        Ispot = I(xSpot, ySpot);

        data = double(Ispot(oq(i,j).binSpot));
        q = quantile(data, oq(i,j).signalPercentiles);

        [iOut, jOut] = find(oq(i,j).binSpot & (Ispot < q(1) | Ispot > q(2)));

        ignoredPixels = zeros(size(oq(i,j).binSpot));
        ignoredPixels(iOut, jOut) = 1;
        oq(i,j).ignoredPixels = ignoredPixels;
        data = data(data>=q(1) & data<=q(2));

        oq(i,j).medianSignal = median(data);

        oq(i,j).meanSignal = mean(data);
    end
end
end

            
            