function T = vFlagIC50Series(T)

fNames = fieldnames(T);
iX = strmatch('x', fNames);
iY = strmatch('y', fNames);
xSeries = fNames{iX};
ySeries = fNames{iY};

badCurve = '00001001';
for i=1:length(T)
    y = T(i).(ySeries);
    x = T(i).(xSeries);
    i0 = find(x == min(x));
    y0 = median(y(i0));
    iLow = find(x == max(x));
    yLow = median(y(iLow));
    
    iNewFlag = find(T(i).primaryR2 < 0.9 & T(i).sRelative > 0.2);
    if ~isempty(iNewFlag)
        for j=1:length(iNewFlag)
            
            strQ = dec2bin(T(i).QcFlag(iNewFlag(j)),8);
            strQ([end-4, end] ) = '1';
            T(i).QcFlag(iNewFlag(j)) = bin2dec(strQ);
        
        end

    end
end
                        
    
   
    
        
    