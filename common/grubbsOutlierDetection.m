function lOutlier = grubbsOutlierDetection(data, alpha, strCentralTendency)
% function lOutlier = grubbsOutlierDetection(data, alpha, varargin)
% Detects outliers according to Grubbs' method
% See http://www.itl.nist.gov/div898/handbook/eda/section3/eda35h.htm
% and
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=
% 3961&objectType=file
%
% IN:
% data, matrix with data
% alpha, significance level [0-1] at which outliers are to
% be detected, (alpha = 0.95 means p =0.05 that the detected outlier is NOT
% an outlier)
% strCentralTendency (dft 'mean') can be mean or median, method to compute the
% central tendency of the set. 
% 
% OUT:
% lOutlier, logical array (size(data)). Element of lOutlier is true if the corresponding element 
% of data is an outlier.


if nargin == 2
        strCentralTendency = 'mean';
end
lOutlier = logical(zeros(size(data)));

while(1)
   tData = data(~lOutlier);
   if isempty(tData)
       break
   end
   g = grubbs(tData, strCentralTendency);
   [G, iMax] = max(g);
   if G>zcritical(1-alpha, length(tData))
       lOutlier(data == tData(iMax(1))) = 1;
   else
       break;
   end   
end

function g = grubbs(data, strCentralTendency)
if isequal(strCentralTendency, 'median');
    mData = median(data);
else
    mData = mean(data);
end
g = abs(data-mData)/std(data);



function zcrit = zcritical(alpha,n)
%ZCRIT = ZCRITICAL(ALPHA,N)
% Computes the critical z value for rejecting outliers (GRUBBS TEST)
tcrit = qt(alpha/(2*n),n-2);
zcrit = (n-1)/sqrt(n)*(sqrt(tcrit^2/(n-2+tcrit^2)));
   
   
