function Rsq = CalcR(Yfit, Ydata)
% Rsq = CalcR(Yfit, YData)
% calculation of Rsq taken from
% "Fitting models to biological Data using ... " Motulsky & Christopolous
% GraphPad Prism
%
SSreg = sum ( (Yfit - Ydata).^2);
sY = size(Ydata);
for i=1:sY(2)
    SStot(i) = sum( (Ydata(:,i) - mean(Ydata(:,i))).^2);
end
Rsq = 1 - SSreg./SStot;