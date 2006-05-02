function z = zscores(data)
% RDW
% z = zscores(data) returns the z-scores of data
% for a matrix. The function works along the columns

if min(size(data)) == 1
    mData = mean(data);
    sData = std(data);
else
    [s1, s2] = size(data);
    mData = repmat(mean(data), s1,1);
    sData = repmat(std(data), s1,1);   
end
z = (data - mData)./sData;
% EOF