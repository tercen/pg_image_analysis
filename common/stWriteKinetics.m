function fid = stWriteKinetics(filename, C, data, stSpotID, WriteOrAppend, ID);
% function fid = WriteKinetics(filename, C,data, GeneID, row, col,
% <WriteOrAppend>, <WellID> )
% string: filename, file to save
% C: vector with x -axis values
% data: matrix with data columns
% structure with fields: name, row col, for identifier
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
    
for j=1:length(stSpotID)
    hdr = [stSpotID(j).name,'_(',num2str(stSpotID(j).row),':',num2str(stSpotID(j).col),')'];
    fprintf(fid, ['\t',hdr]);
end
fprintf(fid,'\n');
for t=1:length(C)
    fprintf(fid, '%d', data(t,1));
    fprintf(fid, '\t%8.2f', data(t,2:sdata(2)));
    fprintf(fid,'\n');
end
fclose(fid);
    