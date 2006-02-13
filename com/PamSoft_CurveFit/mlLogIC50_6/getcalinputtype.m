function inputdef = getcalinputtype
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global logIC50_initial
global logIC50_auto
global logIC50_lower
global logIC50_upper
global hs_initial
global hs_auto
global hs_lower
global hs_upper
inputdef{1} = 'xData:xSeries';
inputdef{2} = 'yData:ySeries';

