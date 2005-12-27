function oq = spotQuantification(varargin);


if length(varargin) == 1
    % use existing object
    bIn = varargin{1};
    if isa(bIn, 'spotQuantification');
        oq = bIn;
        return;
    elseif isstruct(bIn);
        oq = class(bIn, 'spotQuantification');
        return;
    end
end

oq.ID = [];
oq.cx = [];
oq.cy = [];
oq.rotation = [];
oq.backgroundMethod = 'localCorner';
oq.oOutlier = [];
oq.oSegmentation = [];
oq.oProperties = [];
oq.medianBackground = [];
oq.meanBackground = [];
oq.medianSignal = [];
oq.meanSignal = [];
oq.ignoredPixels = [];
oq.backgroundDiameter = 4;

oq = class(oq, 'spotQuantification');
oq = set(oq, varargin{:});


