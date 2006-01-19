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

s.method         = 'Threshold';
s.methodOutput   = [];
s.areaSize       = 1;
% if the spotPitch property has not been set the segmentation algo 
% attempts to calculate the spotPitch from the x and y inputs
% Works only if x(i,j) and y(i,j) are the x and y coordinates of spots
% with index (i,j) in the grid.
s.spotPitch      = [];
s.nFilterDisk    = 0;
s.edgeSensitivity   = [0, 0.005];
s.cLu           = [];
s.mp0          = [];
s.bsSize     = [];
s.bsTrue     = [];

s = class(s, 'segmentation');
if length(varargin) > 1
    s = set(s, varargin{:});
end


