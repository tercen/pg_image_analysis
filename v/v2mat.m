function [M, condition, spotID] = v2mat(v, metric, clAnnotation, badWell);
% function [M, condition, spotID] = v2mat(v, metric, clAnnotation,
% badWell);
[index1{1:length(v)}] = deal(v.Index1);
[index2{1:length(v)}] = deal(v.Index2);
index1 = cell2mat(index1);
index2 = cell2mat(index2);
mx1 = max(index1);
mx2 = max(index2);
if nargin < 4
    badWell = false(mx1, mx2);
end
spotID = vGetUniqueID(v, 'ID');
M = zeros(length(spotID), mx1*mx2);

n = 0;
for row = 1:mx1
    for col = 1:mx2
        iWell = find(index1 == row & index2 == col);
        if ~isempty(iWell) && ~badWell(row, col)
            n = n + 1;
            for j=1:length(clAnnotation)
                condition{n,j} = v(iWell(1)).(clAnnotation{j});
               
            end
            for j = 1:length(iWell)
                iSpot = strmatch(v(iWell(j)).ID, spotID);
                M(iSpot, n) = v(iWell(j)).(metric);
            end
        end
    end
end
try
    [condition(:,1), iSort] = sort(condition(:,1));
     condition(:,2:end) = condition(iSort, 2:end);
catch
    c = cell2mat(condition(:,1));
    [c, iSort] = sort(c);
    condition = condition(iSort,:);
end

M = M(:, iSort);
% EOF
        
    
    
    