function fid = WriteKineticsNoOpts(filename, C, data, GeneID, row, col);
% function fid = WriteKInetics(filename, C,data, GeneID, row, col,
% <WriteOrAppend>, <WellID> )
% string: filename, file to save
% C: vector with x -axis values
% data: matrix with data column
% GeneID: cell array with GeneID's (strings) for each column in data
% row: integer (row on 96 well plate)
% col: integer (column on 96 well plate)
% WriteOrAppend (Flag, 'w' or 'a')
% ID: string

data = [C,data];
data = sortrows(data, 1);
sdata = size(data);

fid = fopen(filename, ['wt']);
if (fid == -1)
    return;
end

fprintf(fid, 'Cycles');
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
    