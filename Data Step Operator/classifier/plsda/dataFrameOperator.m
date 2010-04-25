function fCubeOut = dataFrameOperator(fCubeIn, metaData, folder)
global MaxComponents
global AutoScale
global CrossValidationType
global NumberOfPermutations
global SaveClassifier

%% input checking
iMatch = strmatch('Color', metaData(:,2));
if length(iMatch) == 1
    aGroupLabelName = metaData{iMatch,1};    
else
    error('Grouping must be defined using exactly 1 data color');
end

% strip off header
hdr = fCubeIn(1,:);
fCubeIn = fCubeIn(2:end,:);

iRs = strmatch('rowSeq', hdr);
rowSeq = cell2mat(fCubeIn(:, iRs));
iCs = strmatch('colSeq', hdr);
colSeq = cell2mat(fCubeIn(:, iCs));
mxRow = max(rowSeq);
mxCol = max(colSeq);

iMatch = strmatch('value', metaData(:,2));
if length(iMatch) ==1
    aDataLabelName = metaData{iMatch,1};
else
    error('Only a single quantitation type allowed');
end

iX = strmatch(aDataLabelName, hdr);
X = nan(mxRow, mxCol);

X(sub2ind(size(X), rowSeq, colSeq)) = cell2mat(fCubeIn(:, iX)); X = X';

if any(isnan(X))
    error('Missing values are not allowed');
end
iy = strmatch(aGroupLabelName, hdr);

y = fCubeIn(rowSeq == 1, iy); 
y = y(colSeq(rowSeq ==1)); 
y = nominal(cell2mat(y));
nGroups = length(unique(y));
if nGroups < 2
    error('Grouping should contain as least two different levels')
end

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
[cvRes, cvcPred, cvyPred] = c.run(X,y);

%% finalModel
finalModel = p.train(X,y);

%% runpermutations
[perMcr, perCvRes] = c.runPermutations(X, y, NumberOfPermutations);

%% save runData
save(fullfile(folder, 'runData.mat'), 'cvRes', 'cvcPred','y', 'cvyPred', 'perMcr', 'perCvRes', 'finalModel');

%% save classifier
if isequal(SaveClassifier, 'yes')
    saveName = uiputfile('*.mat', 'Save Classifier As ...');
    if saveName ~= 0
        save(saveName, 'finalModel');
    end
end
%prepare output table in case of 2 group DA
if nGroups == 2
    yPred = repmat(cvyPred(:,2)', size(X,2), 1);
    pamIndex = 2 * yPred -1;
    beta = repmat(finalModel.beta(2:end,1), 1, size(X,1));
    lIdx = sub2ind(size(X'), rowSeq, colSeq);
    fCubeOut = cell(length(rowSeq)+1, 5);
    fCubeOut(1,:) = {'rowSeq', 'colSeq', 'yPred', 'pamIndex', 'beta'};
    beta = beta(lIdx);
    yPred = yPred(lIdx);
    pamIndex = pamIndex(lIdx);
    fCubeOut(2:length(rowSeq)+1,1:2  ) = arrayfun(@(x){x}, [rowSeq, colSeq]);
    fCubeOut(2:length(rowSeq)+1,3:end) = arrayfun(@(x){x}, [yPred, pamIndex, beta]);
else
    error('Multi group output is still under construction')
end


    
    












