function p = preProcess(varargin)

if length(varargin) == 1
    % copy input object to output object
    pIn = varargin{1};
    if isa(p, 'preProcess');
        p  = pIn;
        return
    else
        error(['Cannot create preProcess object from object of class ',class(bIn)]);
    end
end


p.nSmallDisk    = 3;
p.nLargeDisk    = 9;
p.nCircle       = 280;
p.nBlurr        = 60;

p = class(p, 'preProcess');

if length(varargin) > 1
    p = set(p, varargin{:});
end
    