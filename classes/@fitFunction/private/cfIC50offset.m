function varargout = cfIC50offset(x, par)
Y0   = par(1);
Ymax = par(2);
IC50 = par(3);

Y = Y0 + Ymax./(1 + (x/IC50) );
if nargout == 1
    varargout{1} = Y;
    return
end
