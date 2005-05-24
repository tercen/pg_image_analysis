function g = grid(varargin)

if length(varargin) == 1
    % copy input object to output object
    bIn = varargin{1};
    if isa(bIn, 'grid');
        g = bIn;
        return;
    else
        error(['Cannot create grid object from object of class ',class(bIn)]);
    end
end

g.mask           = [];
g.spotPitch      = [];
g.spotSize       = [];
g.rotation       =  0;
g.method         = 'correlation2D';

g.private        = struct([]);

g = class(g, 'grid');
if length(varargin) > 1

    g = set(g, varargin{:});
end

