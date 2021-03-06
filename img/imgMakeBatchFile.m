function [nImages, msg] = imgMakeBatchFile(fBatchFile,FileList, fSettings, fTemplate,nChannel, pChannelName)
% nImages = imgMakeBatchFile(fBatchFile, DataDir, Filter, fSettings,
%                           fTemplate<,nChannel, pChannelName>)

if (nargin < 5)
    nChannel = 0;
    pChannelName = '';
end

nImages = 0;
szNames = size(FileList); szNames = szNames(2);

fid = fopen(fBatchFile, 'wt');
msg = [];
if (fid == -1)
    msg = ['Could not open batchfile: ', fBatchFile];
    return;
end
% check for existence of template and configuration:

if exist(fSettings, 'file') ~= 2
    msg = ['Could not find Imagene configuration file: ',fSettings];
    return;
end
if exist(fTemplate, 'file') ~= 2
    msg = ['Could not find Imagene template file: ', fTemplate];
end


fprintf(fid, '<Batch>\n');
for n=1:szNames
    dest = FileList(n).fPath;
    iB = findstr(dest, '\'); iB = iB(length(iB));
    dest = dest(1:iB-1);
    nImages = nImages + 1;
    fprintf(fid, '<Entry>\n');
    fprintf(fid, '<Image>%s</Image>\n', FileList(n).fPath);
    fprintf(fid, '<Template>%s</Template>\n',fTemplate);
    fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
    fprintf(fid, '<Destination>%s</Destination>\n', dest);
    fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
    fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);		
    fprintf(fid, '</Entry>\n');
end

%write footer
fprintf(fid, '</Batch>\n');
fclose(fid);
%