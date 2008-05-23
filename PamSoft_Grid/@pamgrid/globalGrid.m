function [x,y,rot,sp] = globalGrid(pgr, I, varargin)
%[x,y,rot] = globalGrid(pgr, I, varargin)
opdef.cycle = [];
opdef.exposure = [];
op = setVarArginOptions(opdef, [], varargin{:});

% create the grid image. Note that the grid image may be resized with
% respect to the input images for efficiency. rsf is the resize factor.
[Igrid, rsf]  = createGridImage(pgr, I, 'exposure', op.exposure, ...
                                        'cycle', op.cycle);
arsc = rescale(pgr.oArray, rsf);
                                    
% call the grid finding method
[x,y,rot, sp] = gridFind(arsc, Igrid);

% scale back to the origibal size and return
x = x/rsf(1);
y = y/rsf(2);
x(x<1) = 1;
y(y<1) = 1;
x(x>size(I,1)) = size(I,1);
y(y>size(I,2)) = size(I,2);
