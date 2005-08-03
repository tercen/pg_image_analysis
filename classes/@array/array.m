function g = array(varargin)
% array.array
% function oArray = array(varargin)
% This is the constructor for class array.
% See matlab documentation on object oriented programming
%
% oArray = array() returns an array object
% oArray = array(oArray), where oArray is an array object, returns a copy of oArray
% oArray = array('prop1', 'val1', 'prop2', 'val2', ...) returns an array object
% with prop1 set to val1 etc.  
%
% To retrieve a property use the array.get method:
% val = get(oArray, 'prop');
% get(oArray) will return all oArray properties as the corresponding
% structure.
%
% To set properties use the array.set method:
% oArray = set(oArray, 'prop1', val1, 'prop2', 'val2, ...
% 
% array properties:
% mask: nRows x nCols matrix where nRows and nCols give the dimensions of
% the array. mask(i,j) must be set to 1 if position [i,j] in the array is a grid
% reference, otherwise 0.
%
% spotPitch: scalar, set to pitch of the spots in the array in pixels
%
% spotSize: scalar, set to approximate diameter of the spots in the array in pixels
%
% xOffset, yOffset nRows  x nCols matrix containing y,x (respectively) offsets from ideal
% in units spotPitch:
%   xOffset(i,j) = -0.5 means x coordinate of point X 0.5 a pitch to the
%   left. 
%   When xOffset, or yOffset are left empty the grid will dft to
%   zeros(nRows, nCols);
% 
% rotation: vector, (dft: 0) , use to set the possible rotations in degrees of the array to be probed.
%
%
%(note, the more rotations, the slower the grid finding)
% method: string, one method currently supported (dft: 'correlation2D')
% EXAMPLE:
% To define an 4 x 4 array with grid references on the corner, a spotSize
% of 10 pixels, a spotPitch of 15 pixels.
% oArray = array();
% mask = zeros(4);
% mask(1,1) = 1; mask(1,4) = 1;mask(4,1) = 1;mask(4,4) = 1
% % probe rotations between -2 and 2 degreesl, step 0.25;
% rot = [-2:0.2:2];
% oArray = set(oArray, 'mask', mask, 'rotation', rot, 'spotPitch', 15,
% 'spotSize', 10);
%
% array public member functions (ex get and set)
% See also array/gridFind, array/fromFile.

if length(varargin) == 1
    % copy input object to output object
    bIn = varargin{1};
    if isa(bIn, 'array');
        g = bIn;
        return;
    else
        error(['Cannot create array object from object of class ',class(bIn)]);
    end
end

g.mask           = [];
g.xOffset        = [];
g.yOffset        = [];
g.spotPitch      = [];
g.spotSize       = [];
g.rotation       =  0;
g.method         = 'correlation2D';
g.private        = struct([]);


g = class(g, 'array');
if length(varargin) > 1

    g = set(g, varargin{:});
end

