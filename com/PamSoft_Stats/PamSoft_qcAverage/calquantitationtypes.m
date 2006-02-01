function [quantitationTypes, confidenceTypes] = calQuantitationTypes(data)
global outlierMethod
global outlierMeasure

if isempty(outlierMethod)
    outlierMethod = getpropdefault('outlierMethod');
end
if isempty(outlierMeasure)
    outlierMeasure = getpropdefault('outlierMeasure');
end

[val, map] = getpropenumeration('outlierMethod');
strOutlierMethod = char(map(val == outlierMethod));

data = double(data(:));
rawMean     = mean(data);
rawMedian   = median(data);
rawStd      = std(data);

if isequal(strOutlierMethod, 'none')
    iOut = false(size(data));
else
    oOut = outlier( 'method', strOutlierMethod, ...
                    'measure', outlierMeasure);
    iOut  = detect(oOut, data);
end
fltMean = mean(data(~iOut));
fltMedian = median(data(~iOut));
fltStd = std(data(~iOut));

quantitationTypes   = [rawMean, rawMedian, rawStd, fltMean, fltMedian, fltStd]';
confidenceTypes     = double(iOut);
