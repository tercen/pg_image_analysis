function [pRes, wRes] = computeFit(pgfit, X, Y, W)

% check size and shape of input
if nargin < 4
    W = [];
end


[sx1, sx2] = size(X);
if sx1 < sx2
    X = X';
    Y = Y';
    W = W';
end
if min(size(X)) ~= 1
    error('Input argument X must be a vector');
end

[sy1, sy2] = size(Y);
if sy1 ~= length(X)
    error('Size of input argument Y does not correspond to that of X');
end

if isempty(W) 
    W = ones(size(Y));
elseif size(W) ~= size(Y)
    error('Size of input argument W must be equal to that of Y'); 
end
% --------------------

if isequal(pgfit.TolMode, 'Relative')
    bRelative = logical(1);
else
    bRelative = logical(0);
end


% loop over the datasets Y(:,i)
for i=1:sy2

    % get the default initalization parameters from the modelObject
    [p0, pLower, pUpper] = getInitialParameters(pgfit.modelObj, X, Y(:,i));

    % override initialization parameters when specified in pgfit object
    if ~isempty(pgfit.iniPars)
        p0 = pgfit.iniPars;
    end
    if ~isempty(pgfit.lbPars)
        pLower = pgfit.lbPars;
    end
    if ~isempty(pgfit.ubPars)
        pUpper = pgfit.ubPars;
    end

    switch pgfit.fitMethod
        case 'Normal'
            options = optimset('Jacobian', pgfit.jacobian,'Display', 'none' ,'MaxFunEvals', 10, 'TolX', 1e-8);
            nIter = 0;
            while(1)
                nIter = nIter + 1;
                [pOut, ChiSqr, Res, ExitFlag] = lsqnonlin(@lsqFun, p0, pLower, pUpper,options,pgfit, X, Y(:,i), W(:,i));

                if bRelative
                    p0 = min(abs(p0), 1e-10);
                    eps = abs((p0-pOut)./p0);
                else
                    eps = abs(p0-pOut);
                end

                if eps <= pgfit.TolX | nIter >= pgfit.maxIterations
                    break;
                else
                    p0 = pOut;
                end
            end
            pRes(:,i) = pOut;
            wRes(:,i) = W;

        case 'Robust'
            options = optimset('Jacobian', pgfit.jacobian,'Display', 'none' ,'MaxFunEvals', 5, 'TolX', 1e-8);
            nIter = 0;
            
            % first iteration before reweight
            [pOut, ChiSqr, Res, ExitFlag,dummy1,dummy2,jac] = lsqnonlin(@lsqFun, p0, pLower, pUpper,options,pgfit, X, Y(:,i), W(:,i));
            fit = getCurve(pgfit.modelObj, X, pOut);
            wRob = calcRobustWeights((Y(:,i)-fit), jac, pgfit.robTune);
            wIn = W(:,i).*wRob;
            
            while(1)
                nIter = nIter + 1;
                [pOut, ChiSqr, Res, ExitFlag,dummy1,dummy2,jac] = lsqnonlin(@lsqFun, p0, pLower, pUpper,options,pgfit, X, Y(:,i), wIn);
                fit = getCurve(pgfit.modelObj, X, pOut);

                wRob = calcRobustWeights((Y(:,i)-fit), jac, pgfit.robTune);
                wIn = W(:,i).*wRob;
                
                if bRelative
                    p0 = min(abs(p0), 1e-10);
                    eps = abs((p0-pOut)./p0);
                else
                    eps = abs(p0-pOut);
                end

                if eps <= pgfit.TolX | nIter >= pgfit.maxIterations
                    break;
                else
                    p0 = pOut;
                end
            end
            pRes(:,i) = pOut;
            wRes(:,i) = wIn;
        case 'Filter'
            cppgFit = pgFit(pgfit);
            cppgFit = set(cppgFit, 'fitMethod','Robust');
            [pOut, w] = computeFit(cppgFit, X, Y(:,i), W(:,i));
            W(w < 0.1) = 0;
            cppgFit = set(cppgFit, 'fitMethod', 'Normal');
            [pRes(:,i), wRes(:,i)] = computeFit(cppgFit, X, Y(:,i), W(:,i));

    end %<switch>
end %<i loop>
