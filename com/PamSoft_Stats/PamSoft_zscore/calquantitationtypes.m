function [quantitationTypes, confidenceTypes] = calQuantitationTypes(dataArray)
zData    = dataArray(:,1);
mData   = dataArray(:,2);
sData   = dataArray(:,3);

zData = double(zData(:));
zscore = (zData-mData)./sData;


quantitationTypes   = [zscore]';
confidenceTypes     = [];
