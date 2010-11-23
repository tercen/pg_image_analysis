function addFactorColumn(dataColumn, levels, name, type)
global data
if isempty(data)
    data = dataset;
end
save([name,'.mat'], 'dataColumn', 'levels', 'type')

warning('off');
type = paste(cellstr(type),',');
aData = dataset({nominal(dataColumn(:), levels), name});
aData = set(aData, 'VarDescription', cellstr(type));
data = [data,aData];
% below is a sp[ecial for this component
%if contains(cellstr(type), 'Color')
%    data = set(data, 'UserData', name);
%end
