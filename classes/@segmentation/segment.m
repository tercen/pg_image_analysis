function s = segment(s, I, cx, cy);


if isempty(s.spotAreaSize)
    error('segmentation property spotAreaSize is not defined');
end

switch s.method
    case 'threshold1'
        s.spots = segThr1(I, cx, cy, s.spotAreaSize);
end
