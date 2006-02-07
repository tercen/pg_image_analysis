function [quantitationTypes, confidenceTypes] = calQuantitationTypes(xData, yData)
[xData, iSort] = sort(xData);
yData = yData(iSort);
fy = gradient(yData);
Vini = max(fy);
confidenceTypes = [];
quantitationTypes = Vini;

