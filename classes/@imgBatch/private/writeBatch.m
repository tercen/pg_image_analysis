function msg = writeBatch(sBatchFile, stBatch)
[fid,em]  = fopen(sBatchFile, 'wt');
msg = [];
if fid ==-1
    msg = em;
    return;
end
fprintf(fid, '%s\n', '<Batch>');
clNames = fieldnames(stBatch);
for i=1:length(stBatch)
    fprintf(fid, '%s\n', '<Entry>');
    for j=1:length(clNames)
        sOpenItem       = ['<',clNames{j},'>'];
        sCloseItem      = ['</',clNames{j},'>'];
        sValue = stBatch(i).(clNames{j});
        if ~ischar(sValue)
            sValue = num2str(sValue);
        end
        
        fprintf(fid, '%s%s%s\n', sOpenItem, sValue, sCloseItem);
    end
    fprintf(fid, '%s\n', '</Entry>');
end
fprintf(fid, '%s\n', '</Batch>');

