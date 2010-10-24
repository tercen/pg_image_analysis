function addIntColumn(dataColumn, name, type)
global data
global outlierSpec
if isempty(data)
    data = dataset;
end
warning('off');
type = paste(cellstr(type),',');
aData = dataset({int32(dataColumn(:)), name});
aData = set(aData, 'VarDescription', cellstr(type));
data = [data,aData];

