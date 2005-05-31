%% Real Multiplex
% May 17, 2005
% Rik de Wijn, PamGene International.
% Test LDA feature selection on real multiplex data
% Note that the "Load Data" and "Reorganize ..." steps take up the bulk of
% processing time
%% Initialize
clear all
close all
%% Load Data
% This loads an annotated v-file. 
dDir = 'D:\temp\data\SO-0310C4 standardkinase050404DPy-run 09-41-52 05-Apr-2005\pamgene-on standardkinase050404DPy-run 09-41-52 05-Apr-2005-ImageResults\_CurveFit Results';
vFile = 'mediansigmbg_rw.v.mat';
v = load([dDir, '\', vFile]);
v = v.v;
%% Reorganize and Remove Bad Wells
% The Vini data is reorganized from the v-file into a nPeptides x nWells matrix,
% with nPeptides the number of peptides, and nWells the number of wells.
% The columns are sorted according to annotation.
%
% Bad wells are marked by keyword "#null" in the annotation and are removed
% from the data. 
%
% Wells that are to belong to the trainig set are marked - in this particular data set -  by the the
% keywords 'none' (no treatment, just 5-plex) or 'w/o' (w/o a particular enzyme) in the "treatment" annotation field of v. 
% Based on these wells are assigned to the either the training set or the
% test set.

uID = vGetUniqueID(v, 'ID');
M = reshape([1:96],12,8)';
done = logical(zeros(size(M)));
lTraining = logical(zeros(96,1));
lBadWell = logical(zeros(96,1));

Vini         = zeros(length(uID), length(M));
endLevel    =  zeros(length(uID), length(M));
for i=1:length(v)
    iPep = strmatch(v(i).ID, uID);
    iWell = M(v(i).Index1, v(i).Index2);
    Vini(iPep, iWell) = max(v(i).Vini, 1e-12);
    endLevel(iPep, iWell) = v(i).EndLevel;
    if ~done(v(i).Index1, v(i).Index2)
        clAnnotation(iWell) = cellstr([v(i).enzymes,'_',v(i).treatment]);
        done(v(i).Index1, v(i).Index2) = 1;
        if ~isempty(findstr('none', v(i).treatment)) | ~isempty(findstr('w/o', v(i).treatment))
            lTraining(iWell) = 1;
        end
        if ~isempty(findstr(clAnnotation{iWell}, '#null'))
            lBadWell(iWell) = 1;
        end
    end
end
[clAnnotation, iSort] = sort(clAnnotation);
endLevel = endLevel(:, iSort);
Vini = Vini(:, iSort);
lTraining = lTraining(iSort);
lBadWell = lBadWell(iSort);
Vini = Vini(:, ~lBadWell);
endLevel = endLevel(:, ~lBadWell);
clAnnotation = clAnnotation(~lBadWell);
lTraining = lTraining(~lBadWell);

%% Preprocess the data
% Columns are normalized by dividing by the column mean. This puts the
% focus on the relative signals of the peptides within a well instead of on
% absolute signals.  

Vini = Vini ./ repmat(mean(Vini), size(Vini,1),1);
endLevel = endLevel./ repmat(mean(endLevel), size(endLevel,1),1);
%% Separate in Training and Test Set
% We proceed with the End Level data only, since the kinetics in this
% particular data set look relatively ugly.
setTraining = endLevel(:, lTraining);
setTest     = endLevel(:, ~lTraining);
clTrainingAnnotation = clAnnotation(lTraining);
clTestAnnotation = clAnnotation(~lTraining);
uAnnotation = clGetUniqueID(clTrainingAnnotation);


%% Class Labels and some Outlier removal
% Creates a class label vector for the training algorithm.

classLabel = zeros(size(clTrainingAnnotation));
sDist = zeros(size(classLabel));
for i = 1:length(uAnnotation);
    iMatch = strmatch(uAnnotation{i}, clTrainingAnnotation);
    classLabel(iMatch) = i;
    mDist = repmat(median(setTraining(:,iMatch),2),1, length(iMatch));
    sDist(iMatch) = sqrt(sum( (setTraining(:,iMatch) - mDist).^2));
end
%lOut = grubbsOutlierDetection(sDist, 0.9, 'median');
% override outleir detection at this level
lOut = zeros(size(sDist));
setTraining = setTraining(:, ~lOut);
clTrainingAnnotation = clTrainingAnnotation(~lOut);
uAnnotation = clGetUniqueID(clTrainingAnnotation);
classLabel = classLabel(~lOut);

%% Graphs of the Training Set
% Follow graphs of the training set per class.
nTraining = length(uAnnotation);
for i=1:nTraining
    figure
    plot(setTraining(:,classLabel == i))
    set(gcf, 'position', [232   434   616   232])
    title(['Class ',num2str(i),': ',uAnnotation{i}], 'interpreter', 'none') 
    xlabel('peptide index');
    ylabel('end level (a.u.)');
end

%% Train the model
% Use the stpr toolbox function lda to create a projection of the data
% on a "nDim" dimensional coordinate system, that maximizes the class separation.
% The warning message is related to the low number of replicates used, and
% seems reasonably benign.
nDim = 3;
train.X = setTraining;
train.y = classLabel;
test.X  = setTest;
test.y  = zeros(1,size(test.X,2)); % dummy

model = lda(train, nDim);
trainProj = linproj(train, model);
testProj  = linproj(test, model);
%% Show the model obtained from the training set
% For graphing purposes the training set is split up in a "RET" and a "Src"
% part.
% In the graphs the wells are shown in the lda space. Dots are colored
% according to class. Clarity of the class separation depends on the
% projection used in the 3D plot but it is clear from the graphs that
% colors tend to clusetr together.
%% Training Set RET
figure(99)
colors = colormap('hsv');
cStep = floor(2*length(colors)/nTraining);
uTraining = clGetUniqueID(clTrainingAnnotation);
iRet = strmatch('5-plex-RET', uTraining);
iSrc = strmatch('5-plex-Src', uTraining);
uRet = uTraining(iRet);
uSrc = uTraining(iSrc);
figure(99)
hold off
for j = 1:length(uRet)
    iMatch = strmatch(uRet{j}, clTrainingAnnotation);
    cLabel = trainProj.y(iMatch(1));
    c = trainProj.X(1:nDim, iMatch);
    mc = median(c,2);
    h(j) = plot3(c(1,:), c(2,:), c(3,:), '.', 'color', colors((j-1)*cStep + 1,:), 'MarkerSize', 20);
    text(mc(1), mc(2), mc(3), ['+',num2str(cLabel)], 'color', colors((j-1)*cStep + 1,:))
    title('RET');
    hold on
end
set(gca, 'cameraposition', [130.1650 -125.7005   75.2406]);
hLegend = legend(h, uRet);
set(hLegend, 'Location', 'northeastoutside', 'interpreter', 'none');
plot3(0,0,0,'k+')
%% Training Set Src
figure(100)
hold off
sDist = -ones(size(clTrainingAnnotation));
for j = 1:length(uSrc)
    iMatch = strmatch(uSrc{j}, clTrainingAnnotation);
    cLabel = trainProj.y(iMatch(1));
    c = trainProj.X(1:nDim, iMatch);
    mc = median(c,2);
    mmc = repmat(mc, 1, size(c,2));
    h1(j) = plot3(c(1,:), c(2,:), c(3,:), '.', 'color', colors((j-1)*cStep + 1,:), 'MarkerSize', 20);
    text(mc(1), mc(2), mc(3), ['+',num2str(cLabel)], 'color', colors((j-1)*cStep + 1,:));    
    sDist(iMatch) = 
    title('Src');
    hold on
end
set(gca, 'cameraposition', [130.1650 -125.7005   75.2406]);
hLegend = legend(h1, uSrc);
set(hLegend, 'Location', 'northeastoutside', 'interpreter', 'none');
plot3(0,0,0,'k+')
%% Add Test Data to RET
% Enter test conditions to show with RET training set
clear clTest
clear hTest
clTest{1} = '5-plex-RET_Gleevec';
clTest{2} = '5-plex-RET_28839766-AAC';
   

uTest = clGetUniqueID(clTestAnnotation);
nTest = length(uTest);
cStep = floor(length(colors)/nTest);

figure(99)
for j=1:length(clTest)
    iMatch = strmatch(clTest{j}, clTestAnnotation);
    c = testProj.X(:, iMatch);
    hTest(j) = plot3(c(1,:), c(2,:), c(3,:), 'diamond','color', colors((j-1)*cStep + 1,:) )
end
set(hTest, 'MarkerFaceColor', [0.9, 0.9, 0.9], 'MarkerSize', 5);
%% Add Test Data to Src
clear clTest
clear hTest
clTest{1} = '5-plex-Src_Gleevec';
clTest{2} = '5-plex-Src_Staurosporin';
clTest{3} = '5-plex-Src_28839766-AAC';
   

uTest = clGetUniqueID(clTestAnnotation);
nTest = length(uTest);
cStep = floor(length(colors)/nTest);

figure(100)
for j=1:length(clTest)
    iMatch = strmatch(clTest{j}, clTestAnnotation);
    c = testProj.X(:, iMatch);
    hTest(j) = plot3(c(1,:), c(2,:), c(3,:), 'diamond','color', colors((j-1)*cStep + 1,:) )
end
set(hTest, 'MarkerFaceColor', [0.9, 0.9, 0.9], 'MarkerSize', 5);

