function [Map, Message] = vMap(v, strIDField, ID, strValField);
% function [Map, Message] = vMap96(v, strIDField, ID, strValField)
% ***********
% ***********
% Returns a 8 x 12 array with a 96 well map of requested value
% IN:
% v           ,data structure as produced by vLoad
% strIDField  ,str identifying the field to serve that contains the ID
% ID          ,ID as str or value (note that vMap96 can handle only one ID,
%               see vArrange96 for retrieving multiple IDs)
% strValField ,str identifying the values to be put in the map
% OUT:
% Map, (8x12) map with requested values arranged according to 96 well
% format
% Message, 0 zero if no error otherwise an error message
%
% EXAMPLE:
%
% [Map, Message] = vMap96(v, 'ID', '290-1 mM', 'Vini');
% returns a 96 well map of the Vini value of v-vectors (spots) with ID '290-1mM'
%
% SEE: vArrange96, vPick

fldNames = fieldnames(v);
Map = [];
Message = 0;
% check if the rquested fields exists

if isempty(strmatch(strIDField, fldNames, 'exact') )
    Message = ['input structure v does not have the requested field: ',strIDField];
    return;
end

if isempty(strmatch(strValField, fldNames, 'exact') )
    Message = ['input structure v does not have the requested field: ',strValField];
    return;
end

if isempty(strmatch('Index1', fldNames, 'exact') ) | isempty(strmatch('Index2', fldNames, 'exact') )
    Message = ['input structure v does not contain multiwell attributes Index1 and/or Index2'];
    return;
end
    
% check if it is a string field or a numeric field, copy to array or
% cellstr, check for matches
if (isnumeric(v(1).(strIDField)))
    if ~isnumeric(ID)
        Message = ['Error: ',strIDField,' contains numeric data but ID is not numeric'];
        return;
    end
    
    
    a = zeros(length(v),1);
    for i  = 1:length(v)
        a(i) = v(i).(strIDField);
    end
    iMatch = find(a == ID);
    if (isempty(iMatch))
        Message = ['Requested ID not found: ', num2str(ID)];
        return;
    end
        
else
    if ~ischar(ID)
        Message = ['Error: ',strIDField, ' contains string data but ID is not a string'];
        return;    
    end
    a = cell(length(v),1);
    for i  = 1:length(v)
        a(i) = cellstr(v(i).(strIDField));
    end
    iMatch = strmatch(ID, a, 'exact');
    
    if (isempty(iMatch))
        Message = ['Requested ID not found: ', ID];
        return;
    end
end 

% if length(iMatch) > 96
%     Message = ['Warning: found more than 96 elements. ', num2str(length(iMatch) - 96), ' element(s) not in map'];
% end
% Map = NaN * ones(8,12);

% check if index is numeric, if not convert



if ~isnumeric(v(1).Index1)
    clUnique = vGetUniqueID(v, 'Index1');
    for i=1:length(v)
        iI = strmatch(v(i), clUnique);
        v(i).Index1 = iI;
    end
end
if ~isnumeric(v(1).Index2)
    clUnique = vGetUniqueID(v, 'Index2');
    for i=1:length(v)
        iI = strmatch(v(i), clUnique);
        v(i).Index2 = iI;
    end
end

for i=1:length(v)
    Index1(i) = v(i).Index1;
    Index2(i) = v(i).Index2;
end

mIndex1 = max(Index1);
mIndex2 = max(Index2);

Map = NaN * ones(mIndex1, mIndex2);

for i=1:length(iMatch)
    row = v(iMatch(i)).Index1;
    col = v(iMatch(i)).Index2;
  
    Map(row,col) = v(iMatch(i)).(strValField);    
end 