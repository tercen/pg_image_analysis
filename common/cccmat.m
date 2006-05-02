function m = cccmat(data)
nCols = size(data,2);
for i=1:nCols
    for j= 1:nCols
        m(i,j) = ccc(data(:,i), data(:,j));
    end
end
% EOF