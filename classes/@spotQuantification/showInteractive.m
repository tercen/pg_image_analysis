function hPresenter = showInteractive(oQ, I, xSeries)
if nargin < 3
    xSeries = 1:size(oQ,3);
end
hPresenter = presenter(I, oQ, xSeries);
% EOF