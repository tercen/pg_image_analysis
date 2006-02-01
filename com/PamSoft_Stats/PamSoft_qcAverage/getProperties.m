function pdef = getProperties
pdef(1).name = 'outlierMethod';
pdef(1).dft = uint8(1);
pdef(1).enumVal = uint8([0,1]);
pdef(1).enumMap = {'none', 'iqrBased'};
%
pdef(end+1).name = 'outlierMeasure';
pdef(end).dft = 1.5;
pdef(end).enumVal = [];
pdef(end).enumMap = [];