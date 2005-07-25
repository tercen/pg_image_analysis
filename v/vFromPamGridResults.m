function [vSpots, vGen] = vFromPamGridResults(resultFile, excludeFields)
% [vSpots, vGen] = vFromPamGridResults(resultFile, excludeFields)

if nargin == 1
    excludeFields = [];
end

vSpots = [];

fid = fopen(resultFile, 'rt');
if fid == -1
    error(['Could not open: ', resultFile]);
end
% read in general data if required
if nargout == 2
    while(1)
        line = fgetl(fid);
        if isequal(line, '<General>');
            vGen = readGeneral(fid);
            break;
        end
        if line == -1
            break;
        end
    end
    frewind(fid);
end

while(1)
    line = fgetl(fid);
    if isequal(line, '<Spots>');
        vSpots = readSpots(fid, excludeFields);
        break;
    end
    if line == -1
        break;
    end
end
fclose(fid);
% sub functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vGen = readGeneral(fid)
vGen = [];
while(1)
    line = fgetl(fid);
    if isequal(line, '</General>');
        break;
    end
    if line == -1
        break;
    end
    clEntry = strread(line, '%s', 'delimiter', '\t');
    fieldName = clEntry{1};
    % remove spaces from fieldname
    iSpace = findstr(fieldName, ' ');
    if ~isempty(iSpace)
        fieldName(iSpace) = '_';
    end
    % numeric field?
    fieldVal = str2num(clEntry{2});
    if ~isempty(fieldVal)
        vGen.(fieldName) = fieldVal;
    else
        vGen.(fieldName) = clEntry{2};
    end
end

function vSpots = readSpots(fid, exHdr)
vSpots = [];
% the first line is the header line
line = fgetl(fid);
if isequal(line, '</Spots>');
    return;
end
if line == -1
    return;
end
clHdr = strread(line, '%s', 'delimiter', '\t');

for i=1:length(clHdr)
    % check for excluded fields and forbidden characters
    if ~any(strcmp(clHdr{i}, exHdr))
        fieldName  = clHdr{i};
        iSpace = findstr(fieldName, ' ');
        if ~isempty(iSpace)
            fieldName(iSpace) = '_';
        end
        iPoint = findstr(fieldName, '.');
        if ~isempty(iPoint)
            fieldName(iPoint) = '_';
        end
        clFieldName{i} = fieldName;
    else
        clFieldName{i} = -1;
    end



end
% now read in the spots
n = 0;
while(1)
    line = fgetl(fid);
    if isequal(line, '</Spots>');
        return;
    end
    if line == -1
        return;
    end
    clValue = strread(line, '%s', 'delimiter', '\t');
    n = n+1;
    for i=1:length(clFieldName)
        if clFieldName{i} ~= -1
            val = str2num(clValue{i});
            if isempty(val)
                val = clValue{i};
            end
            try
                vSpots(n).(clFieldName{i}) = val;
            catch
                clFieldName{i} = -1;
            end

        end
    end
end

   



    
