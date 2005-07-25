function [clID, msg] = vGetUniqueID(v, fName)
% clID = vGetUniqueID(v, fName)
% return the unique values in structure v, field fName

% check if field fName exists
names = fieldnames(v);
clID = cellstr('');
msg = [];
if isempty(strmatch(fName, names, 'exact'))
    msg = ['vGetUniqueID: input structure v does not contain required field ',fName,'.'];
    return
end

[clList{1:length(v)}] = deal(v.(fName));
clID = clGetUniqueID(clList);
