function varargout = getCurve(f, x, p)

[sp1, sp2] = size(p);

if f.jacFlag & nargout == 2
    bJac = 1;
else
    bJac = 0;
end
bJac = logical(bJac);

for i=1:sp2
    strFunction = f.strFitFunctionName;
    if bJac
        [y(:,i), J(:,:,i)]  = feval(strFunction, x, p(:,i));
    else
        y(:,i) = feval(strFunction,x, p(:,i));
    end
end

if bJac
    varargout{1} = y;
    varargout{2} = J;
else
    varargout{1} = y;
end



