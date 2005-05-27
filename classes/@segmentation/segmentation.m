function s = segmentation(I, cx, cy, varargin)

if length(varargin) == 1
    % use existing object
    bIn = varargin{1};
    if isa(bIn, 'segmentation');
        s = bIn;
        s = get(s);
        s.spots = [];
        return;
    else
        error(['4th argument must be an segmentation object']);
    end
else
    s.rotation       =  0;
    s.method         = 'threshold1';
    s.areaSize       = [];
    s.dftSpotDiameter    = 12; 
    classifier.minDiameter          = 10;
    classifier.maxDiameter          = 15;
    classifier.minThrEff            = 0.7;
    classifier.maxAspectRatio       = 1.4;
    classifier.minFormFactor        = 0.7;
    s.classifier = classifier;
  
    s.spots          = struct([]);
end

s = class(s, 'segmentation');
if length(varargin) > 1
    s = set(s, varargin{:});
end

s = segment(s, I, cx, cy);
