function yax0(hAxis)
if nargin = 0
    hAxis = gca
end

axes(hAxis)
v = axis;
v(3) = 0;
axis(v);