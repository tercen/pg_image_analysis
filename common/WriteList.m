function fid = WriteList(filename, resFileName, data, GeneID, row, col, WriteOrAppend, ID);
% function fid = WriteList(filename, C,data, GeneID, row, col,
% <WriteOrAppend>, <WellID> )
% string: filename, file to save
% C: vector with x -axis values
% data: matrix with data columns
% GeneID: cell array with GeneID's (strings), 1 for each column in data
% row: integer (row in array layout)
% col: integer (col in array layout)
% WriteOrAppend (Flag, 'w' or 'a')
% ID: string



if (nargin < 7)
    WriteOrAppend = 'w';
end
fid = fopen(filename, [WriteOrAppend,'t']);
if (fid == -1)
    return;
end

if (nargin < 8)
    fprintf(fid, 'File Name');
else
    fprintf(fid, ID);
end



for j=1:length(GeneID)
    hdr = [char(GeneID(j)),'_(',num2str(row(j)),':',num2str(col(j)),')'];
    fprintf(fid, ['\t',hdr]);
end
fprintf(fid,'\n');
sData = size(data);
for t=1:sData(1)
    dataName = char(resFileName(t));
    iSlash = findstr(dataName, '\');
    if ~isempty(iSlash)
        iLastSlash = iSlash(length(iSlash));
        dataName = dataName( iLastSlash+1:length(dataName));
    end

    fprintf(fid, '%s\t', dataName);
    fprintf(fid, '%8.2f\t', data(t,1:sData(2)));
    fprintf(fid,'\n');
end
fclose(fid);
    