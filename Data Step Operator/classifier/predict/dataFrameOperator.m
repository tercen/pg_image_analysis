function fCubeOut = dataFrameOperator(fCubeIn, metaData, folder)
% Class Predictor
% Version 1.0 (R2009B MCR)
% Creator: Rik de Wijn
% Last Modification Data: May-7-2010
% Support status: supported
% Type: Matlab Operator Step
% Description: Predicts the class of new samples based on a previously
% stored classifier. The Operator prompts the user for selecting this
% classifier from the file system. This is a generic operator supporting
% all classifiers that created using the BN - Matlab Operator
% interface. The Operator relies on the spotID's to verify that the stored
% classifier is consistent with the new input data.
% 
%INPUT:
%Array data from Bionavigator Spreadsheet. Optionally, grouping can be defined using a single DataColor. 
%Using more than a single value per cell results in an error, missing values are not allowed.
%SpotID's have to specified in the BN spreadsheet
%
%PARAMETERS
%1. ShowGraphicalOutput [yes(dft), no], if no the graphical SHOWRESULTS
%output is suppressed.
%
%OUTPUT (RETURNED TO BIONAVIGATOR):
%Per sample: 
%y<ClassName>, class affinity p for each class predicted using the
%classifier. The predicted class is the one with the largest affinity.
%pamIndex (2 class prediction only): y predictions converted to the "PamIndex" format.
%
%OUTPUT (SHOWRESULTS)
%1. Plot of cross validated y predictions in "PamIndex" format (Only for 2-class prediction when grouping is available). 
%2. Tab delimited text file (.xls, best viewed using MS-Excel) with details
% on predictions and classifier performance (only when grouping is
% available).
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
%#function mgPlsda
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
outHdr{2} = 'colSeq';
n = 2;
for i=1:length(classifier.finalModel.uGroup)
    outHdr{n+i} = ['y',classifier.finalModel.uGroup{i}];
    yp = repmat(cr.yPred(:,i)', size(X,2),1);
    fCubeOut(2:length(rowSeq)+1, n+i) = arrayfun(@(x){x}, yp(lIdx));
end
if length(classifier.finalModel.uGroup) == 2
    n = length(outHdr);
    outHdr{n+1} = 'pamIndex';
    fCubeOut(2:length(rowSeq)+1, n+1) = arrayfun(@(x){x}, 2*yp(lIdx) - 1);
end
fCubeOut(1,:) = outHdr;
%% save runData for showResults
save(fullfile(folder, 'classPredictRunData.mat'), 'cr', 'lastUsed');
