function v2gs(outFile, vFile, aFile, qType)
% v2gs
% input arguments:
% 1. outFile: name for the output (genespring file);
% 2. vFile: location of the v-file
% 3. aFile: location of the annotation file
% 4. qType: required quantitation type (Vini, EndLevel etc.)

disp('loading v-file, takes a while ...')
drawnow;
[v, msg] = vLoad(vFile);
if isempty(v)
    error(['Problem loading: ',vFile,'. ',msg]);
end
disp('annotating ...')
drawnow;
[v, annFields, msg] = vAnnotate96(v, aFile);
if ~isempty(msg)
    error(['problem annotating using: ',aFile,'. ',msg]);
end
[M, annValues, spotID] = v2mat(v, qType, annFields);
disp('creating genespring file ...')
drawnow;
mat2genespring(outFile, M, spotID, annValues, annFields); 
disp(['done, created: ',outFile,'.']);
% EOF