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
