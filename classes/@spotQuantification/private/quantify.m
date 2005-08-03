function oq = quantify(oq, I, cx, cy)
methodStr = oq(1,1).backgroundMethod;


switch methodStr
    case 'interleaved'
        [bgMedian, bgMean, badSpot]= backgroundInterleaved(oq(1,1), I, cx, cy);
end
[nRows, nCols] = size(oq);

for i=1:nRows
    for j=1:nCols
        if badSpot(i,j)
            oq(i,j).isSpot = 0;
        end

        oq(i,j).medianBackground = bgMedian(i,j);
        oq(i,j).meanBackground   = bgMean(i,j);
        sArea = size(oq(i,j).binSpot);

        xSpot = oq(i,j).cLu(1):oq(i,j).cLu(1)+sArea(1)-1;
        ySpot = oq(i,j).cLu(2):oq(i,j).cLu(2)+sArea(2)-1;
        Ispot = I(xSpot, ySpot);

        data = double(Ispot(oq(i,j).binSpot));
        oq(i,j).medianSignal = median(data);
        oq(i,j).meanSignal = mean(data);
        ignoredPixels = zeros(size(oq(i,j).binSpot));
        oq(i,j).ignoredPixels = ignoredPixels;

    end
end


            
            