function clList = vList(v, sSeparator)
% function clList = vList(v)
if nargin < 2
    sSeparator = '\t';
end

clNames = fieldnames(v);
nFields = length(clNames);
nVecs = length(v);
% First line are headers
strList = '';
for i=1:nFields
    strList = [strList,sprintf(['%s',sSeparator],char(clNames(i)))]; 
end   
clList(1) = cellstr(strList);

for j=1:nVecs
    strList = '';
    for i=1:nFields
        strF = char(clNames(i));
        if isnumeric(v(j).(strF))
            a = num2str(v(j).(strF));
            strList = [strList, sprintf(['%s',sSeparator],a)];
        elseif iscellstr(v(j).(strF))
            a = char(v(j).(strF));
            strList = [strList, sprintf(['%s',sSeparator],a)];
        else    
            strList = [strList, sprintf(['%s',sSeparator],v(j).(strF))];
        end        
    end
    clList(j+1) = cellstr(strList);
end
