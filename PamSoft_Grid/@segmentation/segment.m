function sOut = segment(s, I, cx, cy, rotation)
% s = segment(s, I, cx, cy, rotation)
if ~isequal(size(cx),size(cy))
    error('The number of x coordinates must be equal to the number of y coordinates');
end
% if min(size(cx)) < 2
%     error('The grid must include at least 2 rows and two columns, use dummy spots if necessary.');
% end

if isempty(s.spotPitch)
    error('Parameter ''spotPitch'' has not been defined');
end

if nargin < 5
    rotation = [];
end

switch s.method

    case 'Threshold'
        error('segment by threshold is currently not supported')
        %sOut = segmentByThreshold(s, I, cx, cy, rotation);
    case 'Edge'
        sOut = segmentByEdge(s, I, cx, cy, rotation);
end