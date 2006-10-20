function [importedFields, data] = imageneImport(fPath, fields)
%[importedFields, data] = imageneInport(fPath, fields)
fid = fopen(fPath, 'rt');
% scroll to Begin Raw Data before starting:
if fid == -1
    error(['could not open: ' , fPath, ' for reading']);
end


data = [];
while(1)
    strLine = fgetl(fid);
    if isequal(deblank(strLine), '<Spots>')
        break;
    end
end
% the next line will be the header line
hdrline = fgetl(fid);
% cater for empty line
if isempty(hdrline)
    hdrline = fgetl(fid);
end
clHdr = strread(hdrline, '%s', 'delimiter', '\t');

if nargin == 1
    % read all fields
    bImport = true(size(clHdr));
else
    % only read fields indicated in cell array fields
    bImport = false(size(clHdr));
    if ~iscell(fields)
        error('2nd input argument must be cell array of strings');
    end
    for i =1:length(fields)
        iMatch = strmatch(fields{i}, clHdr);
        if isempty(iMatch)
            warning('pgrImport:fieldNotFound', ['no data field imported for', fields{i}]);
        else
            bImport(iMatch) = true;
        end
    end
end
% now read untill '</Spots>' and import required fields in cell array

n = 0;
while(1)
    dataline = fgetl(fid); 
    if isempty(dataline)
        dataline = fgetl(fid);
    end
    if isequal(deblank(dataline), '</Spots>');
        break;
    end
    n = n+1;
    clData = strread(dataline, '%s', 'delimiter', '\t');
    clData = clData(bImport);
    for j = 1:length(clData)
        data{n,j} = clData{j};
        val = str2num(data{n,j});
        if ~isempty(val)
            data{n,j} = val;
        end
    end

end
importedFields = clHdr(bImport);
fclose(fid);