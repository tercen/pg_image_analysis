function s = segmentation(varargin)

if length(varargin) == 1
    % copy input object to output object
    bIn = varargin{1};
    if isa(bIn, 'segmentation');
        s = bIn;
        return;
    else
        error(['Cannot create segmentation object from object of class ',class(bIn)]);
    end
end

s.rotation       =  0;
s.method         = 'threshold1';
s.spotAreaSize   = [];
s.spots          = struct([]);

s = class(s, 'segmentation');
if length(varargin) > 1

    s = set(s, varargin{:});
end

