function [stBatch, stPp] = lastBatch(b, ResultList)
%
% Select the last image from eaxh directory and use for gridding 

if ~isempty(b.ppObj)
    lpp = 1;
else
    lpp = 0;
end

stPp = [];
nPp = 0;
nEntry = 0;
clUnDir = getUniqueID(ResultList, 'fPath');
[clDirList{1:length(ResultList)}] = deal(ResultList.fPath);  
for i=1:length(clUnDir)
   % loop all dirs and select the last image. 
    iCurrent = strmatch(clUnDir{i}, clDirList);
    [clPump{1:length(iCurrent)}] = deal(ResultList(iCurrent).P);
    for p =1:length(clPump)
        pump = char(clPump{p});
        pump = str2num(pump(2:end));
    end
    
    [mx, imx] = max(pump);
    iCurrentGridImage = iCurrent(imx);
    if lpp
        nPp = nPp + 1;
        bName      = fnRemoveExtension(ResultList(iCurrentGridImage).fName);
        sGridImage =  [ResultList(iCurrentGridImage).fPath,'\GridImage',bName,'.tif'];
        stPp(nPp).src           = [ResultList(iCurrentGridImage).fPath, '\', ResultList(iCurrentGridImage).fName];
        stPp(nPp).gridImage     = sGridImage;
    else
        sGridImage = [ResultList(iCurrentGridImage).fPath, '\', ResultList(iCurrentGridImage).fName];
    end
      
    nEntry = nEntry + 1;
    % entry for the grid image
    stBatch(nEntry).Image            = sGridImage;
    stBatch(nEntry).Template         = b.pathTemplate;
    stBatch(nEntry).Configuration    = b.pathConfiguration;
    stBatch(nEntry).Destination      = ResultList(iCurrentGridImage).fPath;
    stBatch(nEntry).Channel          = b.nChannel;
    stBatch(nEntry).ChannelName      = b.channelName;
    stBatch(nEntry).SubstituteGridImage = 'null';
    stBatch(nEntry).SubstituteGridChannel = b.nChannel;
    stBatch(nEntry).AdjustGrid = 'true';
    stBatch(nEntry).AdjustSpots = 'true';
        
        % srcImages
    for j =1:length(iCurrent)
        nEntry = nEntry+1;
        stBatch(nEntry+1).Image            = [ResultList(iCurrent(j)).fPath, '\', ResultList(iCurrent(j)).fName];
        stBatch(nEntry+1).Template         = b.pathTemplate;
        stBatch(nEntry+1).Configuration    = b.pathConfiguration;
        stBatch(nEntry+1).Destination      = ResultList(iCurrentGridImage).fPath;
        stBatch(nEntry+1).Channel          = b.nChannel;
        stBatch(nEntry+1).ChannelName      = b.channelName;
        stBatch(nEntry+1).SubstituteGridImage = sGridImage; 
        stBatch(nEntry+1).SubstituteGridChannel = b.nChannel;
        stBatch(nEntry+1).AdjustGrid = 'false';
        stBatch(nEntry+1).AdjustSpots = 'true';
    end

end
