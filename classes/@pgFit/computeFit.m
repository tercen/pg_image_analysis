function pRes = computeFit(pgfit, X, Y, W)


% check size and shape of input
[sx1, sx2] = size(X);
if sx1 < sx2
    X = X';
    Y = Y';
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



            %
            %
            %     case 'Robust'
            %         options = optimset('Jacobian', cfFitOpts.jacobian, 'Display', cfFitOpts.FitDisplay, 'MaxFunEvals', 3, 'TolX', 1e-8);
            %         nIter = 0;
            %         while(1)
            %             nIter = nIter + 1;
            %             [fit, jac]  =  feval(cfModelFunc, X, [], p0);
            %             wRob = calcRobustWeights((Y-fit), jac, robTune);
            %             W = W.*wRob;
            %             % re-iterate using robust weights
            %             [pOut, ChiSqr, Res, ExitFlag] = lsqnonlin(@cfGenFit, p0, pLower, pUpper,options, X, Y, W, cfModelFunc);
            %             eps = abs((p0-pOut)./p0);
            %             if eps <= cfFitOpts.TolX | nIter >= cfFitOpts.MaxFunEvals
            %                 break;
            %             else
            %                 p0 = pOut;
            %             end
            %         end
            %


    end %<switch>
end %<i loop>
