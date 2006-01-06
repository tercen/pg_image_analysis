function oq = setSet(q0, oSeg, oProps)
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
  
        if ~isempty(oq(i,j).oSegmentation)
            oq(i,j) = setBackgroundMask(oq(i,j));    
            
        end
        
    end
end

