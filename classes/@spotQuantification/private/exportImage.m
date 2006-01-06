function exportImage(q, fName, pgVersion)
fid = fopen(fName, 'wt');
if fid == -1
    error('exportImage:fileError', '%s', ['Could not open: ', fName]);
end

if nargin < 3
    pgVersion = [];
end
fprintf(fid, '%s\n', '<General>');
fprintf(fid, '%s\t%s\n', 'File Name', fName);
fprintf(fid, '%s\t%s\n', 'Date', date);
fprintf(fid, '%s\t%s\n', 'Version', pgVersion);
fprintf(fid, '\n');
settings = getSettings(q(1,1));
fNames = fieldnames(settings);
for i=1:length(fNames);
    fprintf(fid, '%s\t', fNames{i});
    val = settings.(fNames{i});
    if isnumeric(val)
        fprintf(fid, '%f\n', val);
    else
        fprintf(fid, '%s\n', val);
    end
end
fprintf(fid, '%s\n', '</General>');

[nRows, nCols] = size(q);
results = getResult(q);
results = results(:);
fprintf(fid, '%s\n', '<Spots>');
fNames = fieldnames(results);
fprintf(fid, '%s\t%s\t', 'Row', 'Column');
for i=1:length(fNames)
    fprintf(fid, '%s\t', fNames{i});
end
fprintf(fid, '\n');
for i=1:length(results)
    [row, col] = ind2sub([nRows, nCols], i);
    fprintf(fid, '%d\t%d\t', row, col);
    for j=1:length(fNames)
        val = results(i).(fNames{j});
        if isnumeric(val) && ~isempty(val)
            fprintf(fid, '%f\t', val);
        elseif isnumeric(val) && isempty(val)
            fprintf(fid, '%s\t', 'NULL');
        elseif islogical(val)
            fprintf(fid, '%d\t', val);
        else
            fprintf(fid, '%s\t', val);
        end
    end
    fprintf(fid, '\n');
end

fprintf(fid, '%s\n', '</Spots>');
fclose(fid);

            


