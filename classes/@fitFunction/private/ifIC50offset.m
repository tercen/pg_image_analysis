function [p0, pLow, pHigh] = ifIC50offset(X,Y)

    D = sortrows([X,Y],1);
    X = D(:,1);
    Y = D(:,2);
    
    p0(1) = mean(Y(find(X == max(X))));
    p0(2) = mean(Y(find(X == min(X))));
    MinP1 = 0;
    if p0(1) < MinP1
        p0(1) = MinP1
    end
    
    iRh = find(Y <= (p0(2)-p0(1))/2);
    iLh = find(Y >  (p0(2)-p0(2))/2);
    %iRh= iRh(1);
    %iLh = iLh(length(iLh));
    xRh = log10(mean(X(iRh)));
    xLh = log10(mean(X(iLh)));
    p0(3) =10^((xRh + xLh)/2);
   
    p0 = p0';
    pLow = [MinP1,1e-10]';
    pHigh = [1e8,1e8]';
    