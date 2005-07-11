function s = segment(s, I, cx, cy);


if isempty(s.areaSize)
    error('segmentation property spotAreaSize is not defined');
end

if isequal(class(I), 'uint8')
    mFull = 255;
elseif isequal(class(I), 'uint16');
    mFull = 65535;
else
    mFull = 1;
end

    

switch s.method
    case 'threshold1'
        s.spots = segThr1(I, cx, cy, s.areaSize, mFull);
end

s = spotRegularize(s);