function oq = quantify(oq, I, cx, cy)
methodStr = oq(1,1).backgroundMethod;
qMetric = oq(1,1).quantitationMetric;

switch methodStr
    case 'interleaved'
        bg = backgroundInterleaved(oq(1,1), I, cx, cy);
end
[nRows, nCols] = size(oq);

for i=1:nRows
    for j=1:nCols
        oq(i,j).background = bg(i,j);
        sArea = size(oq(i,j).binSpot);
        xSpot = oq(i,j).cLu(1):oq(i,j).cLu(1)+sArea(1)-1;
        ySpot = oq(i,j).cLu(2):oq(i,j).cLu(2)+sArea(2)-1;
        Ispot = I(xSpot, ySpot);
        data = double(Ispot(oq(i,j).binSpot));
        q = quantile(data, oq(i,j).signalPercentiles);
        data = data(data>q(1) & data<q(2));
        if isequal(qMetric, 'median')
            oq(i,j).signal = median(data);
        elseif isequal(qMetric, 'mean')
            oq(i,j).signal = mean(data);
        end
    end
end

            
            