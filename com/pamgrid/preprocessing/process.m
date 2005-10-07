function ppImage = process(image)
global nSmallDisk
global nLargeDisk
global nCircle
global nBlurr
global resize
global contrast

if isempty(nLargeDisk)
    error('parameter: ''nLargeDisk'' has not been defined');
end
if isempty(nSmallDisk)
    error('parameter: ''nSmallDisk'' has not been defined');
end
if isempty(nCircle)
    error('parameter: ''nCircle'' has not been  defined');
end
if isempty(nBlurr)
    error('parameter: ''nBlurr'' has not been defined');
end

if isempty(resize)
    resize = [256,256];
end
if isempty(contrast)
    contrast = 'equalize';
end

% Types may not be obviuos  when calling by com, so explicitely convert

nSmallDisk = double(nSmallDisk);
nLargeDisk = double(nLargeDisk);
nCircle = double(nCircle);
nBlurr = double(nBlurr);



oPP = preProcess(   'nSmallDisk', nSmallDisk, ...
                    'nLargeDisk', nLargeDisk, ...
                    'nCircle', nCircle, ...
                    'nBlurr', nBlurr);
                
oPP = rescale(oPP, resize(1)/size(image,1));
ppImage = getPrepImage(oPP, imresize(image, resize));

switch contrast
    case 'equalize'
        ppImage = histeq(ppImage);
    case 'linear'
       
    otherwise
        error('Invalid value for parameter ''contrast'' ');
end

