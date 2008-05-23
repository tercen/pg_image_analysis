function [q, I, expTime, cycles] = analyzeImages(pgr, imFiles)
if ~iscellstr(imFiles)
    error('Input argument ''imFiles'' must be a cell array of string');
end
if isequal(pgr.verbose, 'on')
    bVerb = true;
else
    bVerb = false;
end

% load the images
for i=1:length(imFiles)
    try
        I(:,:,i) = imread(imFiles{i});
    catch
        le =  lasterror;
        error(['Error while reading ', imFiles{i}, ': ',le.message ]);
    end
end

% get the image parameters from file, and sort the images to exposure time
% and cycle
[expTime, cycles]  = getImageInfo(imFiles);
if ~isempty(expTime)&& ~isempty(cycles)
    [ec, iSort] = sortrows( [expTime', cycles'], [2,1]);
    expTime = ec(:,1);
    cycles = ec(:,2);
    I = I(:,:, iSort);
elseif isequal(pgr.useImage, 'All')
    error('Could not find embedded image information for use with ''useImage'' option ''All''');
end   
% call the appropriate segmentation/quantification method
switch pgr.seriesMode
    case 'Fixed'        
        q = seriesFixed(pgr, I, 'exposure', expTime,...
                                'cycle', cycles);
    case 'Adapt Local'
        q = seriesAdaptLocal(pgr, I, 'exposure', expTime,...
                                    'cycle', cycles);
    case 'Adapt Global'
          q = seriesAdaptGlobal(pgr, I, 'exposure', expTime,...
                                 'cycle', cycles);
    case 'Adapt All'
         q = seriesAdapt(pgr, I, 'exposure', expTime,...
                                 'cycle', cycles);
end
for i=1:size(q,2)
    
    flags = checkQuantification(pgr.oSpotQualityAssessment, q(:,i));
   
    q(:,i) = setSet(q(:,i), ...
                'isEmpty', flags == 2, ...
                'isBad', flags == 1);
end
% unsort the output such that the columns order of q, the order of images
% in I, and the order of expTime and cycles corresponds to the order in
% imFiles
idxUnsort(iSort) = 1:size(q,2);
q = q(:, idxUnsort);
I = I(:,:,idxUnsort);
expTime = expTime(idxUnsort);
cycles = cycles(idxUnsort);

