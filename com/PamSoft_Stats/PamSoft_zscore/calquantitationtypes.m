function [quantitationTypes, confidenceTypes] = calQuantitationTypes(dataArray)
data    = dataArray(:,1);
mData   = dataArray(:,2);
sData   = dataArray(:,3);

data = double(data(:));
zscore = (data-mData)./sData;


quantitationTypes   = [zscore]';
confidenceTypes     = [];
