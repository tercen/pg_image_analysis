function imgCollectResults(sBatchFile, sRootDir, sConfigurationFile)
% compile
% mcc -m -d [dest dir] imgCollectResults
% messages from msgCollectResults will be written to fid = MSGOUT
% 1: standard out
global MSGOUT;
MSGOUT = 1;
exitCode = 1;

if ~isequal(sRootDir(length(sRootDir)), '\')
    sRootDir = [sRootDir, '\'];
end



if nargin < 3
    sInstrument = 'PS96';
    sMode = 'kinetics';
else
    IniPars.instrument = 'PS96';
    IniPars.mode = 'kinetics';
    [IniPars, fid] = getparsfromfile(sConfigurationFile, IniPars);
    sInstrument = IniPars.instrument;
    sMode = IniPars.mode;
end

[fid, msg] = fopen(sBatchFile, 'rt');
if (fid ~= -1)
    % batchfile exists so start
    imageList = readImageList(fid);
    fclose(fid);
    nImages = length(imageList);
    fprintf(MSGOUT, 'Found %d Images in %s\n', nImages, sBatchFile);
    if (nImages > 0)
        ResultList = makeResultList(imageList, sInstrument);

        % set up directory structure for saving results.
        uniqueFilters = vGetUniqueID(ResultList, 'filter');
        uniqueIntegrationTime = vGetUniqueID(ResultList, 'integrationTime');
        uniqueArrayID = vGetUniqueID(ResultList, 'arrayID');
        dcSucces = 1;
        if ~mkdir(sRootDir, '_Quantified Results'), dcSucces = 0; end
        sDataRoot = [sRootDir, '_Quantified Results\'];
        for iFilters = length(uniqueFilters)
            if ~mkdir(sDataRoot, char(uniqueFilters(iFilters))), dcSucces = 0; end
            for iTimes = 1:length(uniqueIntegrationTime)
                if mkDir([sDataRoot, char(uniqueFilters(iFilters))], char(uniqueIntegrationTime(iTimes)))
                    if ~mkdir([sDataRoot, char(uniqueFilters(iFilters)), '\',char(uniqueIntegrationTime(iTimes))], 'Mean');
                        dcSucces = 0;
                    elseif ~mkdir([sDataRoot, char(uniqueFilters(iFilters)), '\',char(uniqueIntegrationTime(iTimes))], 'Median');
                        dcSucces = 0;
                    elseif~mkdir([sDataRoot, char(uniqueFilters(iFilters)), '\',char(uniqueIntegrationTime(iTimes))], 'Mode');
                        dcSucces = 0;
                    end
                else
                    dcSucces = 0;
                end
            end
        end
        if dcSucces
            nDone = 0;
            %For every filter, integration time and well produce kinetics
            [clFilterList{1:length(ResultList)}] = deal(ResultList.filter);
            fprintf(MSGOUT, 'Collecting results ...\n');
            for iFilters = 1:length(uniqueFilters)
                iCurrentFilter = strmatch(uniqueFilters{iFilters}, clFilterList);
                % select all entries with current filter
                [clTimeList{1:length(iCurrentFilter)}] = deal(ResultList(iCurrentFilter).integrationTime);
                for iTimes = 1:length(uniqueIntegrationTime)
                    iCurrentTime = strmatch(uniqueIntegrationTime{iTimes}, clTimeList);
                    [clArrayList{1:length(iCurrentTime)}] = deal(ResultList(iCurrentTime).arrayID);
                    %select all entries with current time
                    for iArrays = 1:length(uniqueArrayID)
                        iCurrentArray = strmatch(uniqueArrayID{iArrays},clArrayList);
                        [Data, SpotID] = imgIntegrate(ResultList(iCurrentArray), sMode);
                        nDone = nDone + length(iCurrentArray);
                        fprintf(MSGOUT, 'done: %d/%d\n', nDone, length(ResultList) );
                        ci = iCurrentArray(1);
                        fRoot = [ResultList(ci).arrayID,'_',ResultList(ci).filter,'_',ResultList(ci).integrationTime];
                        if isempty(Data) 
                            fprintf(MSGOUT, 'Skipped data because files were inconsistent,\n Data from: %s.\n', fRoot) 
                        else
                            sCurrentDataDir = [sDataRoot,ResultList(ci).filter,'\',ResultList(ci).integrationTime];
                            if ~WriteData(sCurrentDataDir, fRoot, Data, SpotID, sMode)
                                fprintf(MSGOUT, 'Could not open a data file for writing for:\n %s, %s\n', sCurrentDataDir, ResultList(ci).arrayID); 
                            end
                       end
                        
                    end
                end
            end
        else
            exitCode = 0;
            fprintf(MSGOUT, 'Problem creating directories in: %s\n', sRootDir);
        end
    else
        fprintf(MSGOUT, 'No Images found in: %s\n', sBatchFile);
        exitCode = 0;
    end
else
    % batch file could not be opened
    fprintf(MSGOUT, '%s\n',msg)
    exitCode = 0;
end
fprintf(MSGOUT, 'Exit Code: %d\n', exitCode);

function imageList = readImageList(fid)
    nImages = 0;
    sImageStart = '<Image>';
    sImageEnd   = '</Image>';

    % this reads in the list of images that of the batchfile into
    % imageList
    while(1)
        line = fgetl(fid);
        if line == -1
            break;
        end
        iIni = findstr(sImageStart, line);
        if ~isempty(iIni)
            iIni = iIni + length(sImageStart);
            iFin = findstr(sImageEnd, line); iFin = iFin(length(iFin))-1;
            if iFin > 0
                nImages = nImages + 1;
                imageList(nImages) = cellstr(line(iIni:iFin));
            end
        end
    end
    %%%%

function ResultList = makeResultList(imageList, sInstrument)
global MSGOUT;
% this takes the imageList and produces an result structure that will be used to create
% the integrated data.
nListed = 0;
for  i=1:length(imageList)

    resultFile = fnReplaceExtension(char(imageList(i)),'.txt');
    if exist(resultFile, 'file')
        iPeriod = findstr('.', resultFile); iPeriod = iPeriod(length(iPeriod));
        iSlash =  findstr('\', resultFile); iSlash = iSlash(length(iSlash));
        baseName = resultFile(iSlash + 1: iPeriod-1);
        pathName = resultFile(1:iSlash-1);
        % now pick appart the string to get Filter, IntegrationTime, Well,
        % Pumpcycle
        [arrayID, filter, integrationTime, pumpCycle] = ...
            imgReadWFTP(baseName,pathName, sInstrument);
        if ~isempty(arrayID)
            nListed = nListed + 1;
            ResultList(nListed).resultFile = resultFile;
            ResultList(nListed).arrayID = char(arrayID);
            ResultList(nListed).filter = char(filter);
            ResultList(nListed).integrationTime = char(integrationTime);
            ResultList(nListed).pumpCycle = char(pumpCycle);
        else
            fprintf(MSGOUT, 'Skipped data file because the naming format was not recognized: \n%s\n', char(imageList(i)));
        end
    else
        fprintf(MSGOUT, 'No Data found for: %s\n', char(imageList(i)) );
    end

end    
        
function [Data, SpotID] = imgIntegrate(stResultList, sMode);
    Data = struct( 'meanSig'   , [],   'meanBg'    , [], 'meanSigmBg'  , []    , ...
        'medianSig' , [],   'medianBg'  , [], 'medianSigmBg', []    , ...
        'modeSig'   , [],   'modeBg'    , [], 'modeSigmBg'  , []    , 'x', []);

    if isequal(sMode, 'kinetics')
        [clHdr, nSpots] = imgScanFile(stResultList(1).resultFile);
        nCols = length(clHdr);
        iMeanSig    =strmatch('Signal Mean', clHdr, 'exact');
        iMeanBg     =strmatch('Background Mean',clHdr,'exact');
        iMedianSig  =strmatch('Signal Median', clHdr, 'exact');
        iMedianBg   =strmatch('Background Median',clHdr,'exact');
        iModeSig    =strmatch('Signal Mode', clHdr, 'exact');
        iModeBg     =strmatch('Background Mode',clHdr,'exact');
        iGeneID     = strmatch('Gene ID', clHdr, 'exact');
        iRow        = strmatch('Row',clHdr,'exact');
        iCol        = strmatch('Column',clHdr,'exact');
        Data.x = zeros(length(stResultList),1);

        for i=1:length(stResultList)
            [clData, res] = imgReadFile(stResultList(i).resultFile, nSpots, nCols);
            sData = size(clData);
            pCycle = char(stResultList(i).pumpCycle);
            Data.x(i) = str2num(pCycle(2:length(pCycle)));
            if (sData(1) == nSpots) | (sData(2) == nCols)
                for j =1:nSpots
                    SpotID(j).name = char(clData(j, iGeneID));
                    SpotID(j).row  = char(clData(j, iRow));
                    SpotID(j).col  = char(clData(j, iCol));

                    if ~isempty(iMeanSig)
                        Data.meanSig(i,j)       = str2num(char(clData(j,iMeanSig)));
                        Data.meanBg(i,j)        = str2num(char(clData(j,iMeanBg)));
                        Data.meanSigmBg(i,j)    = Data.meanSig(i,j)- Data.meanBg(i,j);
                    end
                    if ~isempty(iMedianSig)
                        Data.medianSig(i,j) = str2num(char(clData(j,iMedianSig)));
                        Data.medianBg(i,j) = str2num(char(clData(j, iMedianBg)));
                        Data.medianSigmBg(i,j) = Data.medianSig(i,j) - Data.medianBg(i,j);
                    end
                    if ~isempty(iModeSig)
                        Data.modeSig(i,j) = str2num(char(clData(j,iModeSig)));
                        Data.modeBg(i,j) = str2num(char(clData(j, iModeBg)));
                        Data.modeSigmBg(i,j) = Data.modeSig(i,j) - Data.modeBg(i,j);
                    end
                end
            else
                % inconsistent data detected
                clHdr = [];
                Data = {[]};
                return;
            end
        end
    end
    
function result = WriteData(rootDir, fRoot, stData, stSpotID, sMode)
if isequal(sMode, 'kinetics')
    if ~isempty(stData.meanSig)
        sig     = sortrows([stData.x, stData.meanSig], 1);
        bg      = sortrows([stData.x, stData.meanBg], 1);
        sigmbg  = sortrows([stData.x, stData.meanSigmBg], 1);
        sData = size(sig);
        sFile = [rootDir,'\Mean\',fRoot,'_MeanSig.dat'];
        res(1) = stWriteKinetics(sFile, sig(:,1), sig(:,2:sData(2)), stSpotID);
        sFile = [rootDir,'\Mean\',fRoot,'_MeanBg.dat'];
        res(2) = stWriteKinetics(sFile, bg(:,1), bg(:,2:sData(2)), stSpotID);
        sFile = [rootDir, '\Mean\', fRoot,'_MeanSigmBg.dat'];
        res(3) = stWriteKinetics(sFile, sigmbg(:,1), sigmbg(:,2:sData(2)), stSpotID);
    end
    if ~isempty(stData.medianSig)
        sig     = sortrows([stData.x, stData.medianSig], 1);
        bg      = sortrows([stData.x, stData.medianBg], 1);
        sigmbg  = sortrows([stData.x, stData.medianSigmBg], 1);
        sData = size(sig);
        sFile = [rootDir,'\Median\',fRoot,'_MedianSig.dat'];
        res(4) = stWriteKinetics(sFile, sig(:,1), sig(:,2:sData(2)), stSpotID);
        sFile = [rootDir,'\Median\',fRoot,'_MedianBg.dat'];
        res(5) = stWriteKinetics(sFile, bg(:,1), bg(:,2:sData(2)), stSpotID);
        sFile = [rootDir, '\Median\', fRoot,'_MedianSigmBg.dat'];
        res(6) = stWriteKinetics(sFile, sigmbg(:,1), sigmbg(:,2:sData(2)), stSpotID);
    end
    if ~isempty(stData.modeSig)
        sig     = sortrows([stData.x, stData.modeSig], 1);
        bg      = sortrows([stData.x, stData.modeBg], 1);
        sigmbg  = sortrows([stData.x, stData.modeSigmBg], 1);
        sData = size(sig);
        sFile = [rootDir,'\Mode\',fRoot,'_ModeSig.dat'];
        res(7) = stWriteKinetics(sFile, sig(:,1), sig(:,2:sData(2)), stSpotID);
        sFile = [rootDir,'\Mode\',fRoot,'_ModeBg.dat'];
        res(8) = stWriteKinetics(sFile, bg(:,1), bg(:,2:sData(2)), stSpotID);
        sFile = [rootDir, '\Mode\', fRoot,'_ModeSigmBg.dat'];
        res(9) = stWriteKinetics(sFile, sigmbg(:,1), sigmbg(:,2:sData(2)), stSpotID);
    end
    if isempty(find(res == -1))
        result = 1;
    else
        result = 0;
    end
end   