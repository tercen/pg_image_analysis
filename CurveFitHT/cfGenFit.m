function varargout = cfGenFit(p, X, Y, W, FitFunc)
% varargout = cfGenFit(p, X,Y, FitFunc)
% generic fitfunction that calls the model function
% for CurveFitHT1.1
    [f, j] = feval(FitFunc, X, [], p);
    wRes = W.*(f-Y);
  
    if (nargout == 1)
        varargout{1} = wRes;
    else
         for i=1:length(p)
            J(:,i) = W.*j(:,i);
         end
        varargout{1} = wRes;
        varargout{2} = J;
    end
    