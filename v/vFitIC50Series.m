function [T, fitFunction, xSeries, ySeries] = vFitIC50Series(T)

fitFunction = 'cfIC50';
fitOptions.TolX = 0.01;
fitOptions.MaxFunEvals = 100;
fitOptions.FitDisplay = 'none';
fitOptions.robTune = 1.5;

fNames = fieldnames(T);
iX = strmatch('x', fNames);
iY = strmatch('y', fNames);
xSeries = fNames{iX};
ySeries = fNames{iY};
fLow = 10;
for i=1:length(T)
    % create series
    x = T(i).(xSeries)';
    y = T(i).(ySeries)';
    q = T(i).QcFlag';
    w = zeros(size(x));
  
    % create weights
    i0 = find(x == min(x));
    y0 = median(y(i0));
    
    for j =1:length(x)
        iReplicate = find(x == x(j));
       % use standard error as weight
        if length(iReplicate) > 1
            w(j) = std(y(iReplicate))/sqrt(length(iReplicate));
        else
            w(j) = 1;
        end
        
        
    end
    
    iFlagged = find(q);
    wQC = w;
    wQC(iFlagged) = 0;
    
    xlin = 1e6 * 10.^(x);
    fitOptions.strMethod = 'Robust';
    [pOut, eFlag, wOut] = cfFit(xlin,y,wQC,fitFunction, fitOptions);
    wOut = wOut./w;
    
    iIn = find(wOut > 0.1);
    [mx,my, stDev, nPoints] = AvReplicates(xlin(iIn), y(iIn));
    wNew = ones(size(mx));
    fitOptions.strMethod = 'Normal';
    
    options = optimset('Display', 'none');
    try
       
        pOut2 = lsqnonlin(@cfGenFit, pOut, [0;0],[1e8;1e8] ,options, mx, my, wNew, fitFunction);
    catch
       pOut2 = zeros(size(pOut)); 
    end
    T(i).pOut(1)    = 0;
    T(i).pOut(2:3)  = pOut2;
   
    T(i).pOutName{1} = 'Y0';
    T(i).pOutName{2} = 'Ymax';
    T(i).pOutName{3} = 'IC50_uM';
    T(i).wOut = wOut;
end