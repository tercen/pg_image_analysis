function [x,y, rot]  = findgrid(image)
global mask
global xOffset
global yOffset
global spotPitch
global spotSize
global rotation

if isempty(image)
    error('image has not been set.');
end

oArray = array( 'mask', mask, ... 
                'xOffset', xOffset, ...
                'yOffset', yOffset, ...
                'spotPitch', spotPitch, ...
                'spotSize', spotSize);
 
if ~isempty(rotation)
    oArray = set(oArray, 'rotation', rotation);
end
[x,y,rot, oArray] = gridFind(oArray, image);


