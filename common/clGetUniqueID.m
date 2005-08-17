function [uID, classLabels] = clGetUniqueID(clList)
% function [uID, classLabels] = clGetUniqueID(clList);
n = 0;
classLabels = zeros(size(clList));
done = false(size(clList));


while any(~done)
    n = n+1;
    sList = clList(~done);
    uID{n} = sList{1};
    %iMatch = strmatch(uID(n), clList);
  
    lMatch = strcmp(uID(n), clList);
    done(lMatch) = true;
    classLabels(lMatch) = n;    
end

    
