function s = segment(s, I, cx, cy);


if isempty(s.areaSize)
    error('segmentation property spotAreaSize is not defined');
end

% Get full scale factor, necessary for auto thersholding
if isequal(class(I), 'uint8')
    mFull = 255;
elseif isequal(class(I), 'uint16');
    mFull = 65535;
else
    mFull = 1;
end

switch s.method
    case 'threshold1'
        if isempty(s.areaSize)
            error('areaSize parameter has not been set');
        end
        s.spots = segThr1(I, cx, cy, s.areaSize, mFull);
        s = spotRegularize(s);
    case 'FilterThreshold'
        if isempty(s.areaSize)
            error('areaSize parameter has not been set');
        end
     
        if isempty(s.nFilterDisk)
            error('nFilterDisk parameter has not been set');
        end
        s.spots = segFilterThr(I, cx, cy, s.areaSize, s.nFilterDisk, mFull);
        s = spotRegularize(s, true);
    case 'test'
       s.spots = segFilterThr2(I, cx, cy, s.areaSize, s.nFilterDisk, mFull);
       s = spotRegularize(s);       
end
