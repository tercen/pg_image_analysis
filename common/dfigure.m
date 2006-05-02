function hFig = dfigure(n)
if nargin == 0
    hFig = figure;
else
    hFig = figure(n);
end
set(hFig, 'windowstyle', 'docked');
