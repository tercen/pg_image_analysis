function s = segmentation(varargin)

if length(varargin) == 1
    % use existing object
    bIn = varargin{1};
    if isa(bIn, 'segmentation');
        s = bIn;
        s = get(s);
        s.spots = [];
        return;
    elseif isstruct(bIn);
        dummy = segmentation();
        s = class(bIn, 'segmentation');
        return;
    
    else
        error(['cannot create a segmentation object from an object of class: ', isa(bIn)]);
    end
end

s.method            = 'Edge';
s.areaSize          = 1;
s.spotPitch         = [];
s.nFilterDisk       = 0;
s.edgeSensitivity   = [0, 0.005];
s.initialMidpoint   = [];
s.finalMidpoint     = [];
s.diameter          = [];
s.chisqr            = [];
s.bsLuIndex         = [];
s.bsSize            = [];
s.bsTrue            = [];


s = class(s, 'segmentation');
if length(varargin) > 1
    s = set(s, varargin{:});
end


