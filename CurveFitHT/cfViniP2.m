function varargout = cfViniP2(X, Y, p)
% Y = p0 + p1*X + p2*X^2 (p2 < 0)
% This function integrates functions for:
% estimating initial guess for fit
% defining default bounds on parameters
% evaluating function F(X) at parameter p = [Y0, YMAX, k]
% evaluating dF(X)/dX at parameter p
%
% DEPENDING ON CALL:
% function  = cfViniP2(X,Y,p)
% [p0, lb, ub] = cfExpAss(X,Y) returns initial guess / lwer bound, upper
% bound for initializing fit
% [F] = cfViniP2(X, [], p)
% returns the fit function F with p(1) = Y0, p(2) = YMAX, p(3) = k
% [F,J] = cfViniP2(X, [],p)
% returns F and the Jacobian matrix J (required for fitting routine)
% [F, J, Fp] = cfViniP2(X, [], p)
% returns F and J and Fp: dF/dX, (can be used to calculate rate)


if nargin == 2
    % no parameters so initial guess required
    p0(1) = Y(1);
    p0(2) = (Y(3) - Y(1)) / (X(3)- X(1));
    dEnd = Y(length(X)) - (p0(1) + p0(2)*X(length(X)));
    p0(3) = min(-1e-7, dEnd/(X(length(X)).^2) ); 
    varargout{1} = p0';
    varargout{2} = [-1e8;-1e8;-1e8];
    varargout{3} = [1e8; 1e8; 0];
    return;
end

F = p(1) + p(2)*X + p(3)*X.*X;
varargout{1} = F;
if nargout == 1  
    return
end
J = [ones(size(X)), X, X.*X];
varargout{2} = J;
if nargout == 2
    return;
end
Fp = p(2) + 2 * p(3) .* X;
varargout{3} = Fp;
