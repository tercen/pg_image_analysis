function varargout = cfLogIC50(x, par)
Y0      = par(1);
Ymax    = par(2);
logIC50 = par(3);
h       = par(4);

Y = Y0 + Ymax./(1 + 10.^((logIC50-x)*h) );
if nargout == 1
    varargout{1} = Y;
    return
end
