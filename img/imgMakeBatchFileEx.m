function [nImages, msg] = imgMakeBatchFileEx(sGridFile, fBatchFile,FileList, fSettings, fTemplate,nChannel, pChannelName)
% nImages = imgMakeBatchFileEx(sMode, fBatchFile, FileList, fSettings, fTemplate, <nChannel>, <pChannelName>)  
% sMode: gridding mode
%       'All'        gridding on every image
%       if not 'All' there are two possibilities:
%       1)  (sGridFile) refers to a field of the input structure FileList.
%           In this case FileList(:).(sGridFile) should reference the full
%           path of the image that should be used for gridding
%       2)  (sGridFile) is not a field of the input structure FileList
%           In this case sGridFile is assumed to refer to a fixed name GridImage present
%            in every image directory.
            

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
    
elseif ~isfield(FileList, sGridFile)
   

    DirList = vGetUniqueID(FileList, 'fPath');
    [clPaths{1:length(FileList)}] = deal(FileList.fPath);
    for n = 1:length(DirList)
      
        sGridImage = [DirList{n}, '\', sGridFile];
        
        
        
        iCurDir = strmatch(DirList(n), clPaths);

        % Image to put the grid on
        nImages = nImages + 1;
        fprintf(fid, '<Entry>\n');
        fprintf(fid, '<Image>%s</Image>\n',sGridImage );
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
            fprintf(fid, '<SubstituteGridImage>%s</SubstituteGridImage>\n',sGridImage);
            fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
            fprintf(fid, '<AdjustGrid>false</AdjustGrid>\n');
            fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
            fprintf(fid, '</Entry>\n');
        end
    end
    
elseif isfield(FileList, sGridFile)
    clUniqueGridFiles = vGetUniqueID(FileList, sGridFile);
    
    for i=1:length(clUniqueGridFiles)
        strFile = clUniqueGridFiles{i};
        
        iSlash = findstr(strFile, '\');
        iSlash = iSlash(length(iSlash));
        dstPath = strFile(1:iSlash-1);

        nImages = nImages + 1;
        fprintf(fid, '<Entry>\n');
        fprintf(fid, '<Image>%s</Image>\n',strFile );
        fprintf(fid, '<Template>%s</Template>\n',fTemplate);
        fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
        fprintf(fid, '<Destination>%s</Destination>\n', dstPath);
        fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
        fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);
        fprintf(fid, '<SubstituteGridImage>null</SubstituteGridImage>\n');
        fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
        fprintf(fid, '<AdjustGrid>true</AdjustGrid>\n');
        fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
        fprintf(fid, '</Entry>\n');    
    
    end
    
    
    for i=1:length(FileList)
            nImages = nImages + 1;
            fprintf(fid, '<Entry>\n');
            fprintf(fid, '<Image>%s</Image>\n',[FileList(i).fPath,'\',FileList(i).fName] );
            fprintf(fid, '<Template>%s</Template>\n',fTemplate);
            fprintf(fid, '<Configuration>%s</Configuration>\n',fSettings);
            fprintf(fid, '<Destination>%s</Destination>\n', FileList(i).fPath);
            fprintf(fid, '<Channel>%d</Channel>\n', nChannel);
            fprintf(fid, '<ChannelName>%s</ChannelName>\n', pChannelName);
            fprintf(fid, '<SubstituteGridImage>%s</SubstituteGridImage>\n',FileList(i).(sGridFile));
            fprintf(fid, '<SubstituteGridChannel>0</SubstituteGridChannel>\n');
            fprintf(fid, '<AdjustGrid>false</AdjustGrid>\n');
            fprintf(fid, '<AdjustSpots>true</AdjustSpots>\n');
            fprintf(fid, '</Entry>\n');
    end
    
end
%write footer
fprintf(fid, '</Batch>\n');
fclose(fid);
%