function fid = WriteKinetics(filename, C, data, GeneID, row, col, WriteOrAppend, ID);
% function fid = WriteKinetics(filename, C,data, GeneID, row, col,
% <WriteOrAppend>, <WellID> )
% string: filename, file to save
% C: vector with x -axis values
% data: matrix with data columns
% GeneID: cell array with GeneID's (strings), 1 for each column in data
% row: integer (row in 96 well plate)
% col: integer (row in 96 well plate)
% WriteOrAppend (Flag, 'w' or 'a')
% ID: string

data = [C,data];
data = sortrows(data, 1);
sdata = size(data);

if (nargin < 7)
    WriteOrAppend = 'w';
end
fid = fopen(filename, [WriteOrAppend,'t']);
if (fid == -1)
    return;
end

if (nargin < 8)
    fprintf(fid, 'Cycles');
else
    fprintf(fid, ID);
end
    
for j=1:length(GeneID)
    hdr = [char(GeneID(j)),'_(',num2str(row(j)),':',num2str(col(j)),')'];
    fprintf(fid, ['\t',hdr]);
end
fprintf(fid,'\n');
for t=1:length(C)
    fprintf(fid, '%d', data(t,1));
    fprintf(fid, '\t%8.2f', data(t,2:sdata(2)));
    fprintf(fid,'\n');
end
fclose(fid);
    