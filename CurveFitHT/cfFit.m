function [pOut, ExitFlag, W] = cfFit(X, Y, W,cfModelFunc, cfFitOpts)
% function F = cfFit(X, Y, W, cfModelFunc, cfFitOpts);
if isempty(W)
    W = ones(size(Y));
end
[p0, pLower, pUpper] = feval(cfModelFunc, X, Y);
switch cfFitOpts.strMethod
    case 'Normal'
        options = optimset('Jacobian', 'on', 'Display', cfFitOpts.FitDisplay, 'MaxFunEvals', 3, 'TolX', 1e-8);
        nIter = 0;
        while(1)
            nIter = nIter + 1;
            [pOut, ChiSqr, Res, ExitFlag] = lsqnonlin(@cfGenFit, p0, pLower, pUpper,options, X, Y, W, cfModelFunc);
            eps = abs((p0-pOut)./p0);
            if eps <= cfFitOpts.TolX | nIter >= cfFitOpts.MaxFunEvals
                break;
            else
                p0 = pOut;
            end
        end                      
   
   
    case 'Robust'
        options = optimset('Jacobian', 'on', 'Display', cfFitOpts.FitDisplay, 'MaxFunEvals', 3, 'TolX', 1e-8);
        nIter = 0;
        while(1)
            nIter = nIter + 1;          
            [fit, jac]  =  feval(cfModelFunc, X, [], p0);
            wRob = calcRobustWeights(Y-fit, jac);
            wIn = W.*wRob;        
            % re-iterate using robust weights
            [pOut, ChiSqr, Res, ExitFlag] = lsqnonlin(@cfGenFit, p0, pLower, pUpper,options, X, Y, wIn, cfModelFunc);
            eps = abs((p0-pOut)./p0);
            if eps <= cfFitOpts.TolX | nIter >= cfFitOpts.MaxFunEvals
                break;
            else
                p0 = pOut;
            end
        end 

end
