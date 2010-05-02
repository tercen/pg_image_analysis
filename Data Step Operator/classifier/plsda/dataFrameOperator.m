function fCubeOut = dataFrameOperator(fCubeIn, metaData, folder)
%ProgID: classifier.plsda
%Version: 1.0
%Creator: Rik de Wijn
%Last Modification Date: May 5, 2010
%Support Status: Supported
%Description: Partial Least Squared Discriminant Analysis
%Type: Matlab Operator Step (requires R2009B version of Matlab runtime)
%Performs partial least squares discriminant analysis. The method has been
%slightly adapted compared to previous versions following some of the
%recommendations in [...]. Multiple group analysis is supported, but
%working with more than 2 groups may not be tha main strength of the
%method.
%The operator trains a PLS classifier based on the data in the calling
%Bionavigator spreadsheet and known grouping. Training involves determining
%the optimal number of PLS components by (inner) cross validation. The
%classifier may be stored for later use with new data (see
%classifier.predict).
%In addition the classifier performance is estimated by (outer) cross validation.
%Here, the optimization of the number of PLS components is repeated for
%each fold of the cross validation using the training set only (double
%cross validation).
%
%INPUT:
%Array data from Bionavigator Spreadsheet with grouping defined using a single DataColor. 
%Using more than a single value per cell results in an error, missing values are not allowed.
%
%PARAMETERS
%1. MaxComponents [10(dft)], the maximum number of PLS-components allowed. 
%2. AutoScale [no(dft), yes], autoscale spots.
%3. CrossValidationType, list of cross validation options.
%4. NumberOfPermutations [0(dft)], number of label permutations required
%5. SaveClassifer [no(dft), yes], if yes the Operator prompts the user for
%saving the obtained classifier.
%6. ShowGraphicalOutput [yes(dft), no], if no the graphical SHOWRESULTS
%output is suppressed.
%
%OUTPUT (RETURNED TO BIONAVIGATOR):
%Per sample: 
%y<ClassName>, class affinity p for each class predicted using the outer
%cross validation, the predicted class is the one with largest affinity.
%pamIndex (2 class prediction only): y predictions converted to the "PamIndex" format.
%Per spot:
%beta(1..N), were N is the number of groups. Relative weights of spots in the class
%prediction rule. Beta(1..N-1) is usually sufficient. Do not use these
%weights for predicting new samples, use the complimentary classifier.predict
%operator!
%
%OUTPUT (SHOWRESULTS)
%1. Plot of cross validated y predictions in "PamIndex" format (2-group
%classification only)
%2. Diagnostics plot showing the final peptide weights plus the weights
%obtained from the succesive cross validation folds.
%3. Diagnostics plot showing the number of pls components used in the final
%model and in the succesive cross validation folds.
%4. Cumulative distribution plot showing the distribution of error rate and <ClassName> 
%predictive value obtained from label permutations (if any).
%5. Tab delimited text file (best viewed using MS-Excel) with details on
%classifier performance and cross validated predictions.
global MaxComponents
global AutoScale
global CrossValidationType
global NumberOfPermutations
global SaveClassifier
global ShowGraphicalOutput

%% input checking and formatting

% strip off header
hdr = fCubeIn(1,:);
fCubeIn = fCubeIn(2:end,:);

iRs = strmatch('rowSeq', hdr);
rowSeq = cell2mat(fCubeIn(:, iRs));
iCs = strmatch('colSeq', hdr);
colSeq = cell2mat(fCubeIn(:, iCs));

iX = -1+strmatch('value', metaData(:,2));
if length(iX) ==1
    X = flat2mat(fCubeIn(:, iX), rowSeq, colSeq);
    X = X';
else
    error('Only a single quantitation type allowed');
end
if any(isnan(X))
    error('Missing values are not allowed');
end

iy = -1 + strmatch('Color', metaData(:,2));
if length(iy) == 1
   y = flat2ColumnAnnotation(fCubeIn(:, iy), rowSeq, colSeq);
else
    error('Grouping must be defined using exactly 1 data color');
end
y = cellstr(cellfun(@cnv, y,'uniform', false));
y = nominal(y);
nGroups = length(unique(y));
if nGroups < 2
    error('Grouping should contain as least two different levels')
end
%% retrieve the spot IDs
iSpotID = -1 + find(strcmp('ID', metaData(:,1)) & strcmp('Spot', metaData(:,2) ) );
if isempty(iSpotID)
    error(' No spotID''s found')
end
spotID = flat2RowAnnotation(fCubeIn(:,iSpotID), rowSeq,colSeq);
%% construct sample names
arrayAnnotationLabels = metaData( strmatch('Array', metaData(:,2)), 1);
arrayIdx = cell2mat(cellfun(@(x)matchNames(x, hdr), arrayAnnotationLabels, 'uniform', false));
arrayAnnotation = fCubeIn(rowSeq == 1, arrayIdx);
arrayAnnotation = arrayAnnotation(colSeq(rowSeq ==1), :);
names = catAnnotation(arrayAnnotation);

%% initialize PLSDA and CV
p = mgPlsda;
if isequal(AutoScale, 'yes')
    p.autoscale = true;
else
    p.autoscale = false;
end
p.features = 1:MaxComponents;
switch CrossValidationType
    case 'LOOCV'
        p.partition = cvpartition(y, 'leave');
    case '10-fold'
        p.partition = cvpartition(y, 'k', 10);
    case '20-fold'
        p.partition = cvpartition(y, 'k', 20);
    case 'resub'
        % option available for test
        p.partition = cvpartition(y, 'resub');
    otherwise
        error(['Invalid value for ''CrossValidationType'': ', CrossValidationType])
end
c = cv;
c.model = p;
c.partition = p.partition;
c.verbose = false;

%% run CV
% X sorted by spotID 
[~, sIdx] = sort(spotID);
revIdx = reverseSortIdx(sIdx);
X = X(:, sIdx);
cvRes = c.run(X,y, names);

%% finalModel
finalModel = p.train(X,y);

%% runpermutations
[perMcr, perCvRes] = c.runPermutations(X, y, NumberOfPermutations);

%% save runData
save(fullfile(folder, 'runData.mat'), 'cvRes','y', 'perMcr', 'perCvRes', 'finalModel');

%% save classifier
if isequal(SaveClassifier, 'yes')
    saveName = uiputfile('*.mat', 'Save Classifier As ...');
    if saveName ~= 0
        save(saveName, 'finalModel', 'spotID');
    end
end
hdr = createOutputHeaders(unique(y));
fCubeOut = cell(length(rowSeq)+1, length(hdr));
fCubeOut(1,:) = hdr;
lIdx = sub2ind(size(X'), rowSeq, colSeq); % linear index for converting matrix to flat output
fCubeOut(2:length(rowSeq)+1,1:2  ) = arrayfun(@(x){x}, [rowSeq, colSeq]);
n = 2;
for i=1:nGroups
     y = repmat(cvRes.yPred(:,i)', size(X,2),1);
     fCubeOut(2:length(rowSeq)+1, n+i) = arrayfun(@(x){x}, y(lIdx));
 end
 n = n+nGroups;
 for i=1:nGroups
     % beta
     % don't forget to unsort according to spotID
     beta = finalModel.beta(2:end,i);
     beta = beta(revIdx);
     beta = repmat(beta,1,size(X,1));
     fCubeOut(2:length(rowSeq)+1, n+i) = arrayfun(@(x){x}, beta(lIdx));
 end
 if nGroups == 2
     yPred = repmat(cvRes.yPred(:,2)', size(X,2), 1);
     pamIndex = 2 * yPred -1;
     fCubeOut(2:length(rowSeq)+1, end) = arrayfun(@(x){x}, pamIndex(lIdx));
 end
%
function hdr = createOutputHeaders(uGroups)
hdr{1} = 'rowSeq';
hdr{2} = 'colSeq';
n = length(hdr);
for i=1:length(uGroups)
   hdr{n+i} = ['y',char(uGroups(i))];
end
n = length(hdr);
for i=1:length(uGroups)
    hdr{n+i} = ['beta',num2str(i)];
end
if length(uGroups) == 2
    hdr{end+1} = 'pamIndex';
end
%
function idx = matchNames(name, list)
idx = find(strcmp(name, list));
idx = idx(1);
%
function txt = catAnnotation(annotation)
annotation = cellfun(@cnv, annotation, 'uni', false);
for i = 1:size(annotation,1)
    txt(i) = cellstr(horzcat(annotation{i,:}));
end
%
function out = cnv(in)
    out = in;
    if isnumeric(out)
        out = num2str(out);
    end
%
        














