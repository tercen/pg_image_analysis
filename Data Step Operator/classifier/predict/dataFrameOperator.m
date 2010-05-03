function fCubeOut = dataFrameOperator(fCubeIn, metaData, folder)
% predict
global ShowGraphicalOutput
%% check and reformat inputs
% strip off header
hdr = fCubeIn(1,:);
fCubeIn = fCubeIn(2:end,:);

iRs = strmatch('rowSeq', hdr);
rowSeq = cell2mat(fCubeIn(:, iRs));
iCs = strmatch('colSeq', hdr);
colSeq = cell2mat(fCubeIn(:, iCs));
iMatch = -1 + strmatch('value', metaData(:,2));
if length(iMatch) ==1
    X = flat2mat(fCubeIn(:, iMatch), rowSeq, colSeq);
    X = X';
    if any(isnan(X))
        error('Missing values are not allowed');
    end
else
    error('Only a single quantitation type allowed');
end

% y, if any
iGroup = -1 + strmatch('Color', metaData(:,2));
if isempty(iGroup)
    y = [];
elseif length(iGroup) == 1
    y = flat2ColumnAnnotation(fCubeIn(:, iGroup),rowSeq, colSeq);
    y = cellstr(cellfun(@cnv, y,'uniform', false));
    y = nominal(y);
else
    error('Grouping must be defined using a single data color')
end

%% retrieve the spot IDs
iSpotID = -1 + find(strcmp('ID', metaData(:,1)) & strcmp('Spot', metaData(:,2) ) );
if ~isempty(iSpotID)
    spotID = flat2RowAnnotation(fCubeIn(:, iSpotID), rowSeq, colSeq);
else
    error('No spotID''s found in data cube');
end

%% construct sample names
arrayAnnotationLabels = metaData( strmatch('Array', metaData(:,2)), 1);
arrayIdx = cell2mat(cellfun(@(x)matchNames(x, hdr), arrayAnnotationLabels, 'uniform', false));
arrayAnnotation = fCubeIn(rowSeq == 1, arrayIdx);
arrayAnnotation = arrayAnnotation(colSeq(rowSeq ==1), :);
names = catAnnotation(arrayAnnotation);

%% prompt user for saved classifier

fpath = fullfile(folder, 'classPredictRunData.mat');
if exist(fpath, 'file')
    runData = load(fpath);
    dftName = runData.lastUsed;
    filter = '*.*';
else
    dftName = pwd;
    filter = '*.mat';
end
[name,path] = uigetfile(filter, 'Open a classifier', dftName);
if name == 0
    error('A classifier must be selected');
end
lastUsed = fullfile(path,name);

classifier = load(lastUsed);

[spotID, sIdx] = sort(spotID);
if ~isequal(sort(classifier.spotID), spotID)
    error('The spot ID''s of the new data do not correspond to that used for the saved classifier');
end
%use the spotID sorted to X to get the predictions
cr = cvResults;

cr.partitionType = 'Not applicable';
cr.models = classifier.finalModel;
cr.sampleNames = names;
cr.group = y;

if ~isempty(cr.group)
    cr.title = 'Test set validation results';
else
    cr.title = 'New sample prediction results';
end
[cr.yPred, cr.cPred] = classifier.finalModel.predict(X(:, sIdx));
cr.y = round(cr.yPred); % serves as a template for the format of y
%% format ypred for output to BN'
fCubeOut = cell(length(rowSeq)+1, size(cr.yPred,2) + 2);
fCubeOut(2:length(rowSeq)+1,1:2  ) = arrayfun(@(x){x}, [rowSeq, colSeq]);
lIdx = sub2ind(size(X'), rowSeq, colSeq);
outHdr{1} = 'rowSeq';
outHdr{2} = 'colseq';
n = 2;
for i=1:length(classifier.finalModel.uGroup)
    outHdr{n+i} = ['y',classifier.finalModel.uGroup{i}];
    yp = repmat(cr.yPred(:,i)', size(X,2),1);
    fCubeOut(2:length(rowSeq)+1, n+i) = arrayfun(@(x){x}, yp(lIdx));
end
fCubeOut(1,:) = outHdr;
%% save runData for showResults
save(fullfile(folder, 'classPredictRunData.mat'), 'cr', 'lastUsed');
