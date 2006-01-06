function sOut = segment(s, I, cx, cy, rotation, parameters);
% s = segment(s, I, cx, cy, rotation, varargin)
% if method is edge: parameters must be the edgeSensitivity
% if method is threshold parameters is pixFlexibility

if size(cx) ~= size(cy)
    error('The number of x coordinates must be equal to the number of y coordinates');
end

if min(size(cx)) < 2
    error('The grid must include at least 2 rows and two columns, use dummy spots if necessary.');
end

if nargin < 5
    rotation = [];
end

switch s.method

    case 'Threshold'
    
        sOut = segmentByThreshold(s, I, cx, cy, rotation);
    case 'Edge'
        sOut = segmentByEdge(s, I, cx, cy, rotation);
    
    case 'test'
       s.spots = segFilterThr2(I, cx, cy, s.areaSize, s.nFilterDisk, mFull);
       s = spotRegularize(s);       
end
