function xax0(hAxis)
if nargin = 0
    hAxis = gca;
end


axes(hAxis)
v = axis;
v(1) = 0;
axis(v);