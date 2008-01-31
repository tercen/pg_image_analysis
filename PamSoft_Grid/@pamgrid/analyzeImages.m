function q = analyzeImages(pgr, imFiles)
assert(iscellstr(imFiles), 'Input argument ''imFiles'' must be a cell array of string');
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

% get the image parameters from file
[expTime, cycles]  = getImageInfo(imFiles);
if isempty(expTime)||isempty(cycles)
    warning('Could not read image parameters from file, results may be inaccurate');
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
        error(['The ', pgr.seriesMode,' setting for the seriesMode property is not yet supported']);
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
