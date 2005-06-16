function [signal, background, sigmbg] = getSignals(oq, qMetric);

if nargin == 1
    qMetric == 'median';
end
switch qMetric
    case 'median'
        sigField = 'medianSignal';
        bgField = 'medianBackground';
    case 'mean' 
        sigField = 'meanSignal';
        bgField = 'meanBackground';
    otherwise
        error('spotQuantification:unknownQuantitationMetric', '%s', ['unknown quantitaion metric (please check case): ', qMetric]);
end


[nRows, nCols] = size(oq);
for i=1:nRows
    for j=1:nCols
        signal(i,j)         = oq(i,j).(sigField);
        background(i,j)     = oq(i,j).(bgField);
        sigmbg(i,j) = signal(i,j) - background(i,j);
    end
end