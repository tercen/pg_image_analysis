function [uID, classLabels] = clGetUniqueID(clList)
% function [uID, classLabels] = clGetUniqueID(clList);
n = 0;
classLabels = zeros(size(clList));
lMatch = logical(zeros(size(clList)));

while any(~lMatch)
    n = n+1;
    sList = clList(~lMatch);
    uID{n} = sList{1};
    iMatch = strmatch(uID(n), clList);
  
    lMatch(iMatch) = 1;
    
    classLabels(iMatch) = n;    
end

    
