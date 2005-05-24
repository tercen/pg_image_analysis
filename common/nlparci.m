function [ci, ase]  = nlparci(beta,resid,J,alpha)
%NLPARCI Confidence intervals for parameters in nonlinear regression.
%   CI = NLPARCI(BETA,RESID,J) returns 95% confidence intervals CI for the
%   nonlinear least squares parameter estimates BETA.  Before calling
%   NLPARCI, use NLINFIT to fit a nonlinear regression model and get the
%   coefficient estimates BETA, residuals RESID, and Jacobian J.
%
%   CI = NLPARCI(BETA,RESID,J,ALPHA) returns 100(1-ALPHA) percent
%   confidence intervals.
%
%   NLPARCI treats NaNs in RESID or J as missing values, and ignores the
%   corresponding observations.
%
%   The confidence interval calculation is valid for systems where the 
%   length of RESID exceeds the length of BETA and J has full column rank.
%   When J is ill-conditioned, confidence intervals may be inaccurate.
%
%   Example:
%      load reaction;
%      [beta,resid,J] = nlinfit(reactants,rate,@hougen,beta);
%      ci = nlparci(beta,resid,J);
%
%   See also NLINFIT, NLPREDCI, NLINTOOL.

%   References:
%      [1] Seber, G.A.F, and Wild, C.J. (1989) Nonlinear Regression, Wiley.

%   Copyright 1993-2004 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2005/05/24 14:37:26 $

if nargin < 3
   error('stats:nlparci:TooFewInputs','Requires three inputs.');
end;
if (nargin < 4 || isempty(alpha))
    alpha = 0.05; % 95% conf intervals
elseif (~isscalar(alpha) || alpha<=0 || alpha >= 1)
    error('stats:nlparci:BadAlpha',...
          'ALPHA must be a scalar between 0 and 1.');
end

% Remove missing values.
resid = resid(:);
missing = find(isnan(resid) & all(isnan(J),2));
if ~isempty(missing)
    resid(missing) = [];
    J(missing,:) = [];
end
[m,n] = size(J);
if m <= n
   error('stats:nlparci:NotEnoughData',...
         'The number of observations must exceed the number of parameters.');
end;

if length(beta) ~= n
   error('stats:nlparci:InputSizeMismatch',...
         'The length of beta must equal the number of columns in J.')
end

% Approximation when a column is zero vector
temp = find(max(abs(J)) == 0);
if ~isempty(temp)
   J(temp,:) = J(temp,:) + sqrt(eps(class(J)));
end;

% Calculate covariance matrix
[Q,R] = qr(J,0);
Rinv = R\eye(size(R));
diag_info = sum(Rinv.*Rinv,2);

v = m-n;
rmse = norm(resid) / sqrt(v);

%calculate ase (RW)
ase = sqrt(diag_info) .* rmse;

% Calculate confidence interval
 
delta = sqrt(diag_info) .* rmse*tinv(1-alpha/2,v);
ci = [(beta(:) - delta) (beta(:) + delta)];
