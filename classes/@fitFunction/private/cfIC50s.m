function varargout = cfIC50s(x, par)
Ymax = par(1);
IC50 = par(2);

Y = Ymax./(1 + (x/IC50) );
if nargout == 1
    varargout{1} = Y;
    return
end
