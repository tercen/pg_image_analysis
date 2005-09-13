%% sFitReport
% Secondary fit report genererated by sFit
%% Settings
disp(['v-File: ', vPath, '\', vName]);
disp(['annotation: ', aPath, '\', aName]);
disp('***');
strMethod = get(oP, 'fitMethod');
strModel = get(oF, 'strModelName');
disp(['fit model: ',strModel,' (',strMethod,')'])
%% Results
% Zp's are calculated using included points from the conditions with lowest
% and largest X (as suitable for IC50, EC50 series).
%
% Error bars in the plots indicate standard error.
for i=1:length(series)
    x = series(i).x;
    y = series(i).y;
    w = ones(size(x));
    w(series(i).out) = 0;
    [pRes, pAse, wOut] = computeFit(oP,x,y,w); 
     dx = abs( (max(x) - min(x))/25);
     xFit = [min(x):dx:max(x)];
     yFit = getCurve(oF, xFit, pRes);
     
    out = false(size(x));
    out(wOut < 0.01) = true;
    figure
    hIn = plot(x(~out), y(~out), '.');
    hold on
    set(hIn, 'color', [0.8, 0.8, 0.8])
    vAx = axis;
    hOut = plot(x(out), y(out), 'rx');
    hFit = plot(xFit, yFit);
    set(hFit, 'color', 'k', 'linewidth', 2);
    xAv = x; yAv = y; outAv = out;
    nAv = 0;
    while length(xAv) > 0
        nAv = nAv + 1;
        X(nAv) = xAv(1);
        iAv = xAv == xAv(1);
        thisOut = outAv(iAv);
        thisY = yAv(iAv);
        Y(nAv) = mean(thisY(~thisOut));
        S(nAv) = std(thisY(~thisOut));
        N(nAv) = length(thisY(~thisOut));
        xAv = xAv(~iAv);
        yAv = yAv(~iAv);
        outAv = outAv(~iAv);
    end

    % filter out entries with no data points left.
    iPoints = N~= 0;
    Y = Y(iPoints);
    X = X(iPoints);
    N = N(iPoints);
    S = S(iPoints);
    avFit = getCurve(oF, X, pRes);
    R2 = CalcR(avFit, Y');
    hAv = errorbar(X, Y, S./sqrt(N), '.');
    set(hAv, 'color', 'k', 'markersize', 20)
    axis(vAx);
    strTitle = [series(i).spotID, ' : ', series(i).annotation];   
    title(strTitle, 'interpreter', 'none');
    set(gcf, 'color', 'w')
    disp('****')
    disp(['Fit results for: ',strTitle])
    clPar = get(oF, 'clParameter');
    for i=1:length(clPar)
        str1 = [clPar{i},'= ', num2str(pRes(i))];
        str2 = ['s.e.= ',num2str(pAse(i))];
        clLine {i} = str1;
        disp([str1,'; ', str2])
        
        
    end
   str = ['R^2= ', num2str(R2)];
   disp(str)
   clLine{end+1} = str;
   xMin = min(X);
   xMax = max(X);
   sMin = S(X == xMin);
   sMax = S(X == xMax);
   yMin = Y(X == xMin);
   yMax = Y(X == xMax);
   zp = 1 - (3*(sMin + sMax)) / abs(yMax-yMin);
   
   str = ['Zp= ', num2str(zp)];
    disp(str)
   clLine{end+1} = str;
   set(gca, 'Position', [0.0961    0.1674    0.5087    0.7313]);
   set(gcf, 'Position', [142   337   620   227])
   createtextbox(gcf, clLine);
   clear clLine;
end
