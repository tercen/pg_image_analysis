function [nImages, msg] = imgMakeBatchFileEx(sGridFile, fBatchFile,FileList, fSettings, fTemplate,nChannel, pChannelName)
% nImages = imgMakeBatchFileEx(sMode, fBatchFile, FileList, fSettings, fTemplate, <nChannel>, <pChannelName>)  
% sMode: gridding mode
%       'All'        gridding on every image
%       If anyother sGridFile is taken as the fixed name of the image to grid on (cfi
%       (PreProcessed.tif) / should be present in every directory.
%       FileList as created by FileHound2

if (nargin < 6)
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
if isequal(sGridFile, 'All')

    for n=1:szNames
        nImages = nImages + 1;
        fprintf(fid, '<Entry>\n');
        fprintf(fid, '<Image>%s</Image>\n', [FileList(n).fPath,'\',FileList(n).fName]);
        fprintf(fid, '<Template>%s</Template>\n',fTemplate);
        fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
        fprintf(fid, '<Destination>%s</Destination>\n', FileList(n).fPath);
        fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
        fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);
        fprintf(fid, '<SubstituteGridImage>null</SubstituteGridImage>\n');
        fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
        fprintf(fid, '<AdjustGrid>true</AdjustGrid>\n');
        fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
        fprintf(fid, '</Entry>\n');
    end

else
    DirList = vGetUniqueID(FileList, 'fPath');
    [clPaths{1:length(FileList)}] = deal(FileList.fPath);
    for n = 1:length(DirList)
        iCurDir = strmatch(DirList(n), clPaths);

        % Image to put the grid on
        nImages = nImages + 1;
        fprintf(fid, '<Entry>\n');
        fprintf(fid, '<Image>%s</Image>\n',[FileList(iCurDir(1)).fPath,'\',sGridFile] );
        fprintf(fid, '<Template>%s</Template>\n',fTemplate);
        fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
        fprintf(fid, '<Destination>%s</Destination>\n', FileList(iCurDir(1)).fPath);
        fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
        fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);
        fprintf(fid, '<SubstituteGridImage>null</SubstituteGridImage>\n');
        fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
        fprintf(fid, '<AdjustGrid>true</AdjustGrid>\n');
        fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
        fprintf(fid, '</Entry>\n');

        for m = 1:length(iCurDir)
            nImages = nImages + 1;
            fprintf(fid, '<Entry>\n');
            fprintf(fid, '<Image>%s</Image>\n',[FileList(iCurDir(m)).fPath,'\',FileList(iCurDir(m)).fName] );
            fprintf(fid, '<Template>%s</Template>\n',fTemplate);
            fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
            fprintf(fid, '<Destination>%s</Destination>\n', FileList(iCurDir(m)).fPath);
            fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
            fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);
            fprintf(fid, '<SubstituteGridImage>%s</SubstituteGridImage>\n',[FileList(iCurDir(m)).fPath,'\',sGridFile]);
            fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
            fprintf(fid, '<AdjustGrid>false</AdjustGrid>\n');
            fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
            fprintf(fid, '</Entry>\n');
        end
    end
end
%write footer
fprintf(fid, '</Batch>\n');
fclose(fid);
%