%****************CALCULATIONS **************************************
disp('Loading ...');
v = vLoad([vPath,'\',vName]);
disp([vPath,'\',vName]);
v = vResetFlags(v);
disp('Annotating ...')
[v, aMsg]  = vAnnotate96(v, [aPath, '\',aName]);
disp([aPath, '\', aName]);
disp('Normalizing ...');
v = vNormalize(v, '290', 4, 0.5);
disp('Making Series ...');
clSkip= ['290';'D6-';'C4-'];;
T = vCreateSeries(v, meas, seriesAnnotation, clDisAnnotation, 'Skip', clSkip);
disp('IC50 Flagging ...');
T = vFlagIC50Series(T);
disp('IC50 Fitting ...')
[T, fitFunction, xSeries, ySeries] = vFitIC50Series(T);
%**************** OUTPUT **************************************
for i=1:length(T)
    figure(i)
    set(gcf, 'Position', [142   337   620   227])
    x = T(i).(xSeries)';
    y = T(i).(ySeries)';
    q = T(i).QcFlag';
    w = T(i).wOut;  
    
    hold off
    pin = feval(fitFunction, 1e6*10.^x,y);    
    xin = x(find(~q&w>0.1));
    yin = y(find(~q&w>0.1));
    h = plot(xin, yin, '.');
    hold on
    set(gca, 'Position', [0.0961    0.1674    0.5087    0.7313]);
    set(h, 'Color', [0.8, 0.8, 0.8]);
    
    xplot = [min(x):(max(x)-min(x))/100:max(x)]';
    fit = feval(fitFunction, 1e6*10.^(xplot), [], T(i).pOut(2:3));
    iguess = feval(fitFunction, 1e6*10.^(xplot), [], pin);
   
    plot(xplot, iguess, 'r--');
    h = plot(xplot, fit, 'k-');
    as = axis;
    set(h, 'LineWidth', 2);
       
    [mx, my, stDev, nPoints] = AvReplicates(xin, yin);
    hE = errorbar(mx, my, stDev./sqrt(nPoints), 'ko');
    set(hE, 'MarkerFaceColor', 'k');
    
    h = plot(x(find(w<=0.1)), y(find(w<=0.1)), 'o');
    set(h, 'Color', [0.8, 0.8, 0.8]);
    h = plot(x(find(q~=0&q~=17)), y(find(q~=0&q~=17)), 'x');
    set(h, 'Color', [0.4, 0.4, 1]);
    h = plot(x(find(q==17)), y(find(q == 17)), '+');
    set(h, 'Color', [0.4, 1, 0.4]);
    axis(as)  
    title(T(i).strDisAnnotation, 'interpreter', 'none')
  
    tResults(1) = cellstr(['logIC50: ', num2str(log10(T(i).pOut(3)/1e6))]);
    tResults(2) = cellstr(['Ymax:    ', num2str(T(i).pOut(2))]);
    tResults(3) = cellstr(['Y0:      ', num2str(T(i).pOut(1))]);    
    createtextbox(gcf,tResults);
    drawnow
end