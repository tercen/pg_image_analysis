function varargout = cfIC50(X, Y, p)
% Y = Y0 + (Ymax-Y0)/(1+10^(X-logIC50))





if nargin == 2
    D = sortrows([X,Y],1);
    X = D(:,1);
    Y = D(:,2);
    
    
    % no parameters so initial guess required
%     p0(1) = 0;%min(Y);
%     MinP1 = 0;
%     if p0(1) < MinP1
%         p0(1) = MinP1;
%     end
    
    p0(1) = mean(Y(find(X == min(X))));
    
    MinP1 = 0;
    if p0(1) < MinP1
        p0(1) = MinP1
    end
    
    iRh = find(Y <= p0(1)/2);
    iLh = find(Y > p0(1)/2);
    %iRh= iRh(1);
    %iLh = iLh(length(iLh));
    xRh = log10(mean(X(iRh)));
    xLh = log10(mean(X(iLh)));
    p0(2) =10^((xRh + xLh)/2);

    
    
    
    
    
    
    varargout{1} = p0';
    varargout{2} = [MinP1,1e-10]';
    varargout{3} = [1e8,1e8]';
    return;
end



Ymax    = p(1);
IC50 = p(2);

F = Ymax./(1 + (X/IC50));
varargout{1} = F;
if nargout == 1  
    return
end
J(:,1) = ones(size(X));
J(:,2) = 1./(1+(X/IC50));
J(:,3) = (Ymax/IC50)./(1+(X/IC50)).^2;
varargout{2} = J;
if nargout == 2
    return;
end
Fp = p(2) * ones(size(X));
varargout{3} = Fp;
