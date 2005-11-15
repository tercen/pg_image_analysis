function override = getOverride(parName)
global xScale
global fitMode
global robTune
global errorMode
global xTolerance
global xToleranceMode
global maxIterations

switch parName
    otherwise
        override = 0;
end

        