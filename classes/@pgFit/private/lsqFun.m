function varargout = lsqFun(p, pgfit, X, Y, W)
% varargout = lsqFun(p, X,Y, FitFunc)
% generic fitfunction that calls the model function
% and calculates the residuals for least square fitting
    
if get(pgfit.modelObj, 'jacFlag') & nargout == 2
     [f, j] = getCurve(pgfit.modelObj, X, p)
     varargout{2} = W.*j(:,i);
else
     f = getCurve(pgfit.modelObj, X, p);
end
varargout{1} = W.*(f-Y);