function oq = setSet(q0, oSeg, oProps, cx, cy)
[nRows, nCols] = size(oSeg);
for i=1:nRows
    for j=1:nCols
        oq(i,j) = q0;
        if ~isempty(oSeg)
            oq(i,j).oSegmentation = oSeg(i,j);
        end
        if ~isempty(oProps)
            oq(i,j).oProperties = oProps(i,j);
        end
        if ~isempty(cx)
            oq(i,j).cx = cx(i,j);
        end
        if ~isempty(cy)
            oq(i,j).cy = cy(i,j);
        end
    end
end
