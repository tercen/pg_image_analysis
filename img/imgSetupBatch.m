function imgSetupBatch(sDataRoot, sConfigurationFile, sTemplateFile, sBatchFile)
% compile:
% mcc -m -d C:\PamSoft\DataAnalysis\img\bin imgSetupBatch ppFun5
%function imgSetupBatch(sDataRoot, sConfigurationFile, sTemplateFile,sBatchFile)
global MSGOUT
MSGOUT = 1;

ppFixedName = 'GridImage.tif';

IniPars.instrument = 'PS96';
IniPars.batchMode = 'Normal';
IniPars.imgConfiguration = '';
IniPars.searchFilter = '*.tif';
IniPars.ppFunctionDefFile = '';
IniPars.ppUseName = 'none';
IniPars.satLevel = 3900;


[IniPars, fid] = getparsfromfile(sConfigurationFile, IniPars);

if ~isequal(IniPars.ppUseName, 'none')
    % this creates a structure with preprocess function definitions
    PPF = imgGetPPFunctions(IniPars.ppFunctionDefFile);
    [ppNames{1:length(PPF)}] = deal(PPF.ppName);
    iPPF = strmatch(IniPars.ppUseName, ppNames, 'exact');
    % iPPF is the index of the requested preprocess function.
    if isempty(iPPF)
        fprintf(MSGOUT, 'The preprocess name that was defined in: %s could not be found in: %s', sConfigurationFile, IniPars.ppFunctionDefFile);
        fprintf(MSGOUT, 'Exit Code: %d\n', 0);
        return
    end
    for i=1:length(PPF(iPPF).ppParVals)
        ppParVals(i) = str2num(char(PPF(iPPF).ppParVals(i)));
    end
end

exitCode = 1;
if (fid ~= -1)
    fprintf(MSGOUT, 'Searching for data under %s ... \n', sDataRoot);
    ImageList = filehound2(sDataRoot, IniPars.searchFilter);
    %based on the required setup mode, the batchfile will now be created.
    if length(ImageList) >= 1
        fprintf(MSGOUT, 'Found: %d Images.\n', length(ImageList));
        if isequal(IniPars.batchMode, 'All')
            % creates the imagene batchfile with gridding for all images
            [nFiles, msg] = imgMakeBatchFileEx(IniPars.batchMode, sBatchFile, ImageList, IniPars.imgConfiguration, sTemplateFile);


            if isempty(msg)
                fprintf(MSGOUT, 'Created batchfile: %s, for %d images.\n', sBatchFile, nFiles);
            else
                fprintf(MSGOUT, 'Could not create batchfile because: %s\n', msg);
                exitCode = 0;
            end


        elseif isequal(IniPars.batchMode, 'Last')
            % find all the different directories in ImageList
            uniqueDirList = vGetUniqueID(ImageList, 'fPath');
            [clAllDir{1:length(ImageList)}] = deal(ImageList.fPath);
            for iDir = 1:length(uniqueDirList)
                fprintf(MSGOUT, 'Preprocessing %d/%d\n',iDir, length(uniqueDirList));
                % in every directory, identify the last image (in cycles)
                iFiles = strmatch(uniqueDirList(iDir), clAllDir);
                clCurDir = {};
				[clCurDir{1:length(iFiles)}] = deal(ImageList(iFiles).fName);
                [clPath{1:length(iFiles)}] = deal(ImageList(iFiles).fPath);
                [clLast, clNotRec] = imgGetLastFileFromList(clCurDir,clPath, IniPars.instrument);
                if ~isempty(clNotRec)
                    for iNr = 1:length(clNotRec)
                        fprintf(MSGOUT, 'Warning: the naming of the following file was not recognized: %s\n', char(clNotRec{iNr}));
                    end
                end
                if ~isempty(clLast)
                    % load the last image / preprocess / save under fixed
                    % name
                    strIlast = [char(uniqueDirList(iDir)),'\',char(clLast)];
                    try
                        Ilast = imread(strIlast);
                    catch
                        fprintf(MSGOUT, 'Could not open: %s\n', strIlast);
                        Ilast = [];
                        exitCode = 0;
                    end
                    % preprocessing
                    if ~isempty(Ilast)
                        if ~isequal(IniPars.ppUseName, 'none');
                            Ilast = feval(PPF(iPPF).ppFunction, Ilast, ppParVals);
                        end
                        imwrite(Ilast, [char(uniqueDirList(iDir)),'\',ppFixedName], 'Compression', 'none');
                    end
                end
            end
            [nFiles, msg] = imgMakeBatchFileEx(ppFixedName, sBatchFile, ImageList, IniPars.imgConfiguration, sTemplateFile);
            if isempty(msg)
                fprintf(MSGOUT, 'Created batchfile: %s, for %d images.\n', sBatchFile, nFiles);
            else
                fprintf(MSGOUT, 'Could not create batchfile because: %s\n', msg);
                exitCode = 0;
            end

        elseif isequal(IniPars.batchMode, 'Average')
            % average all the images from a directory in grid Image.

            uniqueDirList = vGetUniqueID(ImageList,'fPath');
            [clAllDir{1:length(ImageList)}] = deal(ImageList.fPath);
            for iDir = 1:length(uniqueDirList)
                fprintf(MSGOUT, 'Preprocessing %d/%d\n',iDir, length(uniqueDirList));
                iFiles = strmatch(uniqueDirList(iDir), clAllDir);
                % read in all images in directory
                Iav = double(imread([ImageList(iFiles(1)).fPath,'\',ImageList(iFiles(1)).fName]));
                if length(iFiles) > 1
                    for nF = 2:length(iFiles)
                        Iav = Iav + double(imread([ImageList(iFiles(nF)).fPath,'\',ImageList(iFiles(nF)).fName]));
                    end
                end
                % scale to max scale 8bit image
                mxI = max(max(Iav));
                Iav = uint8(255* (Iav/mxI));
                
                % prefilter (if requested) and save
                if ~isequal(IniPars.ppUseName, 'none');
                    Iav = feval(PPF(iPPF).ppFunction, Iav, ppParVals);
                end
                imwrite(Iav,  [char(uniqueDirList(iDir)),'\',ppFixedName], 'Compression', 'none');
            end
            [nFiles, msg] = imgMakeBatchFileEx(ppFixedName, sBatchFile, ImageList, IniPars.imgConfiguration, sTemplateFile);
            if isempty(msg)
                fprintf(MSGOUT, 'Created batchfile: %s, for %d images.\n', sBatchFile, nFiles);
            else
                fprintf(MSGOUT, 'Could not create batchfile because: %s\n', msg);
                exitCode = 0;
            end

        elseif isequal(IniPars.batchMode, 'MultExp')
            % create gridimage based on multiple exposure times.
            % we'll make a combined image from the highest and lowest
            % exposure time for each well, preprocess and save as the grid
            % image.
            
            nFound = 0;
     
            
            for i = 1:length(ImageList)
                % Add CSWFTP  attributes to image list
                [arrayID, filter, expTime, pump, chip, sample] = imgReadWFTP(ImageList(i).fName,[], IniPars.instrument);
                % only keep th eones with naming recognized
                if ~(isempty(pump)|isempty(arrayID)|isempty(expTime)|isempty(filter))
                    nFound = nFound + 1;
                    FoundList(nFound).fName = ImageList(i).fName;
                    FoundList(nFound).fPath = ImageList(i).fPath;
                    FoundList(nFound).C = char(chip);
                    FoundList(nFound).S = char(sample);
                    FoundList(nFound).W = char(arrayID);
                    FoundList(nFound).F = char(filter);
                    FoundList(nFound).T = char(expTime);
                    FoundList(nFound).P = char(pump);
                else
                     fprintf(MSGOUT, 'Warning: the naming of the following file was not recognized: %s\n', ImageList(i).fName);
                end

           end
            
            % get the unique entry list for C (chip) attribute 
            uniqueChip = vGetUniqueID(FoundList, 'C');
            % the C attribute may not be defined in which case the above will
            % return uniqueChip = {''}, we can procedd as if it where
            % defined.
            % loop over the chip ID's
            iDone = 0;
            for iChip = 1:length(uniqueChip)
                
                chipList = cell(length(FoundList),1);
                [chipList{:}] = deal(FoundList.C);
                % find the current match
                iChipMatch = strmatch(uniqueChip{iChip}, chipList);
                chipImageList = FoundList(iChipMatch);
                
                % get the unique wells belonging to the current chip
                uniqueWell = vGetUniqueID(chipImageList, 'W');
                % loop over the wells
                for iWell = 1:length(uniqueWell)
                    iDone = iDone + 1;
                    fprintf(MSGOUT, 'preprocessing %d/%d(-)\n', iDone, 4*length(uniqueChip));
                    wellList = cell(length(chipImageList),1);
                    [wellList{:}] = deal(chipImageList.W);
                    
                    iWellMatch = strmatch(uniqueWell{iWell}, wellList);
                    wellImageList = chipImageList(iWellMatch);
                    % from the current well, get a list of
                    % exposure times used.
                    uniqueExp = vGetUniqueID(wellImageList, 'T');
                    %Finally we have a list of images from the same
                    % well with multiple exposure times. From these
                    % create the gridimage
                    Icomb = combineExposures(wellImageList, IniPars.satLevel);
                    
                    % save at appropriate location = 1levelup
                    giPath = multiExpGridImagePath(wellImageList);
                    for x = 1:length(giPath)
                        try
                            imwrite(Icomb, giPath{x}, 'compression', 'none');
                        catch
                            fprintf(MSGOUT, 'Warning: Could not create the grid image for: %s\n', [sPath, '\',sName]);
                        end
                    end
                end

            end
            
            % add grid image entry to all entries in the imagelist
            
            sGridImage = 'giPath';
            for i = 1:length(FoundList)
                FoundList(i).(sGridImage) = char(multiExpGridImagePath(FoundList(i)));
            end
            
            [nFiles, msg] = imgMakeBatchFileEx(sGridImage, sBatchFile, FoundList, IniPars.imgConfiguration, sTemplateFile);
            if isempty(msg)
                fprintf(MSGOUT, 'Created batchfile: %s, for %d images.\n', sBatchFile, nFiles);
            else
                fprintf(MSGOUT, 'Could not create batchfile because: %s\n', msg);
                exitCode = 0;
            end  
                      
        else
            fprintf(MSGOUT, 'Unknown batch setup mode: %s\n', IniPars.batchMode);
            exitCode = 0;
        end

    else
        fprintf(MSGOUT, 'No images found with: %s\\%s\n', sDataRoot, IniPars.searchFilter);
        exitCode = 0;
    end

else
    fprintf(MSGOUT, 'Could not open setup configuration file: %s\n', sConfigurationFile);
    exitCode = 0;
end
fprintf(MSGOUT, 'Exit Code = %d\n', exitCode);


%--------------------------- Sub functions ------------------------
function Ic = combineExposures(fList, satLevel)
% Creates a combined exposure image from the images in the list.

uniqueExp = vGetUniqueID(fList, 'T');
for i =1:length(uniqueExp)
    str = uniqueExp{i};
    T(i) = str2num(str(2:length(str)));
end
[T, iSort] = sort(T);

%start at the lowest exposure time
[clList{1:length(fList)}] = deal(fList.T);
for i=1:length(T)
   iMatch = strmatch(uniqueExp(iSort(i)), clList);
   
   % if more than one image with the same exposure,
   % select the one with the highest pumpcycle.
   CurrentList = fList(iMatch);
   [pList{1:length(CurrentList)}] = deal(CurrentList.P);
   for j = 1:length(CurrentList)
        str = pList{j};
        P(j) = str2num(str(2:length(str)));
   end
   [mxP, mxIndex] = max(P);
   iMatch = iMatch(mxIndex);
   % cater for the remote possibility that there are duplicate pumpcycles.
   iMatch = iMatch(length(iMatch));
   
   
   % load the next image
   I = imread([fList(iMatch).fPath, '\',fList(iMatch).fName]);
   if i==1
       %First (low exposure image)
       %determine to 16 bit scaling factor
       scaleFac = double(2^16/max(max(I)));
       Ic = immultiply(I, scaleFac);
   else
       % Next images
       % scale accordingg to exposure time relative to the first image)
       
       I = immultiply(I, scaleFac* T(1)/T(i));
       scSatLevel = satLevel * scaleFac * T(1)/T(i);
       Ic(I<scSatLevel) = I(I<scSatLevel);
   end
end

function sName = multiExpGridImagePath(fEntry)
clPath = vGetUniqueID(fEntry, 'fPath');
for i=1:length(clPath)
    sName{i} = [clPath{i},'\GridImage', fEntry(i).C,fEntry(i).W,fEntry(i).F,fEntry(i).S,'.tif'];
end

       
       
       
       


