function varargout = cfViniLin(X, Y, p)
% Y = p0 + p1*X;
% This function integrates functions for:
% estimating initial guess for fit
% defining default bounds on parameters
% evaluating function F(X) at parameter p = [Y0, YMAX, k]
% evaluating dF(X)/dX at parameter p
%
% DEPENDING ON CALL:
% function  = cfViniLin(X,Y,p)
% [p0, lb, ub] = cfExpAss(X,Y) returns initial guess / lwer bound, upper
% bound for initializing fit
% [F] = cfViniLin(X, [], p)
% returns the fit function F with p(1) = Y0, p(2) = YMAX, p(3) = k
% [F,J] = cfViniLin(X, [],p)
% returns F and the Jacobian matrix J (required for fitting routine)
% [F, J, Fp] = cfViniLin(X, [], p)
% returns F and J and Fp: dF/dX, (can be used to calculate rate)


if nargin == 2
    % no parameters so initial guess required
    p0(1) = Y(1);
    p0(2) = ( Y(length(Y)) - Y(1) ) / ( X(length(X)) - X(1));
    
    
    varargout{1} = p0';
    varargout{2} = [-1e8;-1e8];
    varargout{3} = [1e8; 1e8];
    return;
end

F = p(1) + p(2)*X;
varargout{1} = F;
if nargout == 1  
    return
end
J = [ones(size(X)), X];
varargout{2} = J;
if nargout == 2
    return;
end
Fp = p(2) * ones(size(X));
varargout{3} = Fp;
