function mat2genespring(fOutName, data, spotID, annValues, annFields, bParametric)
% function mat2genespring(fOutName, data, spotID, annValues, <annFields>, <bParametric>)
% where data is mat-data.
nAnnFields = size(annValues,2);
nConditions = size(data,2);
nSpots = size(data,1);

if nargin < 6
    bParametric = false(nAnnFields,1);
end
if nargin < 5 | isempty(annFields)
    for j = 1:nAnnFields
        annFields{j} = ['field',num2str(j)];
    end
end
% open file
fid = fopen(fOutName, 'wt');
if fid == -1
    error(['cannot open: ', fOutName]);
end
% write the header
fprintf(fid, '%s\n', fnRemoveExtension(fOutName));
% write the annotations
fprintf(fid, '%s\t', 'meas id ()*');
fprintf(fid ,'%d\t', 1:nConditions);
fprintf(fid, '\n');


for i=1:nAnnFields
    if ~bParametric(i)
        appendStr = '()*';
    else
        appendStr = '()';
    end
    fprintf(fid, '%s\t', [annFields{i},appendStr]);
    for j=1:nConditions
        val = annValues{j,i};
        if ~ischar(val)
            val = num2str(val);
        end
        fprintf(fid, '%s\t', val);
    end
    fprintf(fid, '\n');
end

% write the data entries

% prepare for removing array indices
iMatch = cell2mat(regexp(spotID, '_(\d+:\d+'));
for i=1:nSpots
    strID = spotID{i};
    if ~isempty(iMatch(i)) && iMatch(i) > 1
        strID = strID(1:iMatch(i)-1);
    end
    fprintf(fid, '%s\t', strID);
    fprintf(fid, '%f\t', data(i,:));
    fprintf(fid, '\n');
end
fclose(fid);
% EOF
        
        




