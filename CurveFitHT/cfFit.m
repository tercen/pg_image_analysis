function [pOut, ExitFlag, W] = cfFit(X, Y, W,cfModelFunc, cfFitOpts, p0)
% function F = cfFit(X, Y, W, cfModelFunc, cfFitOpts);

if isfield(cfFitOpts, 'robTune')
    robTune = cfFitOpts.robTune;
else
    robTune = 1;
end

if ~isfield(cfFitOpts, 'jacobian')
    cfFitOpts.jacobian = 'on';
end


if isempty(W)
    W = ones(size(Y));
end

[pX, pLower, pUpper] = feval(cfModelFunc, X, Y);
if nargin < 6
   p0 = pX; 
end
switch cfFitOpts.strMethod
    case 'Normal'
        options = optimset('Jacobian', cfFitOpts.jacobian, 'Display', cfFitOpts.FitDisplay, 'MaxFunEvals', 10, 'TolX', 1e-8);
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
        options = optimset('Jacobian', cfFitOpts.jacobian, 'Display', cfFitOpts.FitDisplay, 'MaxFunEvals', 3, 'TolX', 1e-8);
        nIter = 0;
        while(1)
            nIter = nIter + 1;          
            [fit, jac]  =  feval(cfModelFunc, X, [], p0);
            wRob = calcRobustWeights((Y-fit), jac, robTune);
            W = W.*wRob;        
            % re-iterate using robust weights
            [pOut, ChiSqr, Res, ExitFlag] = lsqnonlin(@cfGenFit, p0, pLower, pUpper,options, X, Y, W, cfModelFunc);
            eps = abs((p0-pOut)./p0);
            if eps <= cfFitOpts.TolX | nIter >= cfFitOpts.MaxFunEvals
                break;
            else
                p0 = pOut;
            end
        end 
 


end
