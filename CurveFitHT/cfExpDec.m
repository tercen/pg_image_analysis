function varargout = cfExpDec(X, Y, p)
% Y = Ymax * exp(-k*x)
% Things function integrates functions for:
% estimating initial guess for fit
% defining default bounds on parameters
% evaluating function F(X) at parameter p = [Y0, YMAX, k]
% evaluating dF(X)/dX at parameter p
%
% DEPENDING ON CALL:
% function  = cfExpAss(X,Y,p)
% [p0, lb, ub] = cfExpAss(X,Y) returns initial guess / lwer bound, upper
% bound for initializing fit
% [F] = cfExpAss(X, [], p)
% returns the fit function F with p(1) = Y0, p(2) = YMAX, p(3) = k
% [F,J] = cfExpAss(X, [],p)
% returns F and the Jacobian matrix J (required for fitting routine)
% [F, J, Fp] = expAss(X, [], p)
% returns F and J and Fp: dF/dX, (can be used to calculate rate)


if nargin == 2
    % no parameters so initial guess required
    
    p0(1) = Y(1);
    XMID  = (max(X) - min(X))/2;
    xi = find(X<XMID);
    if ~isempty(xi)
        xi = xi(length(xi));
    else
        xi = 1;
    end
    
    p0(2) = 1.3/(X(xi));
    varargout{1} = p0';
    varargout{2} = [0;0];
    varargout{3} = [1e8; 1e8];
    return;
end

Ymax   = p(1);
k      = p(2);


F = Ymax*exp(-k*X);
varargout{1} = F;
if nargout == 1  
    return
end
J = [exp(-k*X), -Ymax*exp(-k*X).*X];
varargout{2} = J;
if nargout == 2
    return;
end
Fp = Ymax * -k * exp(-k*X);
varargout{3} = Fp;
