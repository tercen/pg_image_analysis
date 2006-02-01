function inputdef = getcalinputtype
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Ymax_initial
global Ymax_auto
global Ymax_lower
global Ymax_upper
global logEC50_initial
global logEC50_auto
global logEC50_lower
global logEC50_upper
inputdef{1} = 'xData:xSeries';
inputdef{2} = 'yData:ySeries';

