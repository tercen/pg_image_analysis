function showResults(folder)
global MaxComponents
global AutoScale
global CrossValidationType
global NumberOfPermutations
global SaveClassifier
global ShowGraphicalOutput
runDataFile = fullfile(folder, 'runData.mat');
if exist(runDataFile, 'file');
    runData = load(runDataFile);
else
    return
end
% text output to file
fname = [datestr(now,30),'CVResults.xls'];
fpath = fullfile(folder, fname);
fid = fopen(fpath, 'w');
if fid == -1
    error('Unable to open file for writing results')
end
try
    runData.cvRes.print(fid);
    fclose(fid);
    eval(['!open "',folder,'"']);
catch
    fclose(fid);
    error(lasterr)
end

% graph output
if ~isequal(ShowGraphicalOutput, 'no')
    figure
    models = [runData.cvRes.models];
    if length(unique(runData.y)) == 2
        %predictions
        runData.cvRes.pamIndex;
        set(gcf, 'Name', 'Predictions');
        %diagnostics
        figure
        subplot(2,1,1)
        for i =1:length(models)
            cvBeta(:,i) = models(i).beta(2:end,1);
        end
        [sBeta,idx] = sort(runData.finalModel.beta(2:end,1));
        h = plot(cvBeta(idx,:)); set(h, 'color', [0.8,0.8,0.8]);
        hold on
        plot(sBeta,'k', 'linewidth',2)
        xlabel('peptide #');
        ylabel('beta');
        title('Model stability','fontsize', 14)
    end
    subplot(2,1,2)
    hCvN    = plot([models.n],'o-');
    hold on
    hFinalN = plot( [1,length(models)], [runData.finalModel.n, runData.finalModel.n], 'c', 'linewidth', 2);
    set(gca, 'ylim', [0 MaxComponents]);
    xlabel('CV fold #')
    ylabel('Optimal Nr. of Components')
    legend([hCvN, hFinalN], {'CV', 'final model'})
    set(gcf, 'Name', 'PLS-DA Diagnostics')

    % permutation cdf, if any
    %keyboard
    if ~isempty(runData.perCvRes)
        uGroups = unique(runData.cvRes.group);
        figure
        h1 = cdfplot(runData.perMcr);
        set(h1, 'color', 'k')
        hold on
        perPredVal = [runData.perCvRes.predval];
        cStr = 'brgmcy';j = 0;
        h = nan(length(uGroups),1);
        for i=1:length(uGroups)
            j = j+1;
            if j>length(uGroups)
                j = 1;
            end
            h(i) = cdfplot(perPredVal(i,:));
            set(h(i), 'color', cStr(j))
        end
        legEntries = cellfun(@(x) [x, ' PV'], cellstr(uGroups),'uniform', false );
        [~, catDim] = max(size(legEntries));
        legend( [h1;h], cat(catDim,{'MCR'}, legEntries) );
        xlabel('rate')
        set(gcf, 'Name', 'Permutation Results')
    end
end
