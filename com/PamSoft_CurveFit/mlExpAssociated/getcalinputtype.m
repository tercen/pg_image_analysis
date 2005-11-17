function inputdef = getcalinputtype
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations
global xOffset
global Y0_initial
global Y0_auto
global Y0_lower
global Y0_upper
global Yspan_initial
global Yspan_auto
global Yspan_lower
global Yspan_upper
global k_initial
global k_auto
global k_lower
global k_upper
inputdef{1} = 'xData:xSeries';
inputdef{2} = 'yData:ySeries';

