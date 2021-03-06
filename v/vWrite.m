function fid = vWrite(fName, vIndividual, vGeneral, clHdrLines)
% fid = vWrite(fName, vIndividual, vGeneral, clHdrLines)
% writes v-file
% fName: name of v-file
% v structure with entries for the individual spots
% v structure with entries for all spots in the file
% cell array with hdr lines


fid = fopen(fName, 'wt');
if (fid == -1)
    return;
end

if nargin == 4
    for i=1:length(clHdrLines)
        fprintf(fid, '%s\n', char(clHdrLines{i}));
    end    
end
if nargin >= 3
    genList = vList(vGeneral);
    fprintf(fid, '%s\n', 'generalBegin');
    for i=1:length(genList)
        fprintf(fid, '%s\n', char(genList(i)));
    end       
    fprintf(fid, '%s\n', 'generalEnd');
end
fprintf(fid, '%s\n', 'vBegin');
outList = vList(vIndividual);
for i=1:length(outList)
    fprintf(fid, '%s\n', char(outList(i)));
end
fprintf(fid, '%s\n', 'vEnd');
fclose(fid);