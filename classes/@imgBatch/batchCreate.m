function sBatchFile = batchCreate(b)


sBatchFile = [];
% check inputs
if ~exist(b.pathImageResults, 'dir') 
    error(['Directory not found: ', b.pathImageResults]);
end

if ~exist(b.pathTemplate, 'file') & ~isequal(b.pathTemplate, 'idtest')
    error(['file not found: ', b.pathTemplate]);
end

if ~exist(b.pathConfiguration, 'file') & ~isequal(b.pathConfiguration, 'idtest')
    error(['file not found: ',b.pathConfiguration]);
end

msgout(b.log, ['Searching data in: ',b.pathImageResults]);
foundList = filehound(b.pathImageResults, b.imageFilter);
nFiles = length(foundList);
msgout(b.log, ['Found: ',num2str(nFiles)]);

switch b.instrument
    case 'PS96'
        instrumentID = 0;
    case 'PS4'
        instrumentID = 1;
    case 'FD10m'
        instrumentID = 2;
    case 'FD10'
        instrumentID = 3;
    otherwise
        error(['Invalid instrument identifier: ', b.Instrument]);
end




% check all names and keep only the ones with recognized format
[ResultList, clMsg] = getResultList(foundList, instrumentID);
if ~isempty(clMsg)
    for i=1:length(clMsg)
        msgout(b.log, clMsg{i});
    end
end


switch b.gridMode
    % stBatch is used to write the batchfile
    % stPrepList indicates which image must be preprocessed to what if
    % preprocessing is used    
    case 'normal'
        [stBatch, stPrepList] = normalBatch(b,ResultList);
    case 'last'
        [stBatch, stPrepList] = lastBatch(b, ResultList);
    case 'multiexp'
        [stBatch, stPrepList] = meBatch(b, ResultList);
    otherwise
        error(['Invalid value for gridMode: ',b.gridMode]);
end

% preprocessing, if defined
nPreProcess = length(stPrepList);
if ~isempty(b.ppObj)
    for i=1:nPreProcess
        msgout(b.log, ['preprocessing: ',num2str(i),'/',num2str(nPreProcess)]);
        preProcessExe(b.ppObj, stPrepList(i).src, stPrepList(i).gridImage);
    end
end

sBatchFile = [b.pathImageResults,'\',b.batchID,'_batchfile.bch'];
msgout(b.log, ['Creating batch file for: ',num2str(length(stBatch)),' images']);
msg = writeBatch(sBatchFile, stBatch);
if ~isempty(msg)
    error(['Error creating: ',sBatchFile,': ', msg]);
end
