function [a,b] = linRes(x, y, varargin)
%function [a,b] = linRes(x, y, varargin)
a = [];
b = [];

sX = size(x);
if sX(1) < sX(2)
    x = x';
    y = y';
end


if nargin > 2
    if isequal(varargin{1}, 'y0')
        y0 = varargin{2};
        a = x\(y-y0);
        b = y0;
    end
else
        c = [ones(size(x)), x]\y;
        a  = c(1);
        b  = c(2);
end
