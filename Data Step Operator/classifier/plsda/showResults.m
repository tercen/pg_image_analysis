function showResults(folder)
global MaxComponents
global AutoScale
global CrossValidationType
global NumberOfPermutations
global SaveClassifier
runDataFile = fullfile(folder, 'runData.mat');
if exist(runDataFile, 'file');
    runData = load(runDataFile);
else
    return
end

if length(unique(runData.y)) == 2
    %predictions
    pamIndex = 2*runData.cvyPred(:,2)-1;
    figure
    cvc.showpred(pamIndex, runData.y);
    set(gca, 'ytick', [-1,0,1], 'ygrid', 'on');
    set(gcf, 'Name', 'Predictions');
    %diagnostics
    figure
    subplot(2,1,1)
    models = [runData.cvRes.models];
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
    subplot(2,1,2)
    plot([models.n],'o-')
    xlabel('CV fold #')
    ylabel('Optimal Nr. of Components')
    set(gcf, 'Name', 'PLS-DA Diagnostics')
    % ROC
    figure
    uGroups = unique(nominal(runData.y));
    [f1,t1] = perfcurve(runData.y,pamIndex,char(uGroups(1)));
    [f2,t2] = perfcurve(runData.y,pamIndex,char(uGroups(2)));
    h = plot([f1,f2], [t1,t2], 'linewidth',2); 
    set(h(1), 'color','b');set(h(2), 'color', 'r')
    legend(h, cellstr(uGroups));
    title('ROC','fontsize', 14)
    xlabel('False Pos/Neg Rate')
    ylabel('True Pos/Neg rate')
    set(gcf, 'Name', 'ROC');
    % permutation cdf, if any
    if ~isempty(runData.perCvRes)
        figure
        h1 = cdfplot(runData.perMcr);
        set(h1, 'color', 'k')
        hold on
        perPredVal = [runData.perCvRes.predval];
        h2 = cdfplot(perPredVal(1,:));
        set(h2, 'color', 'b')
        h3 = cdfplot(perPredVal(2,:));
        set(h3, 'color', 'r')
        legend([h1,h2,h3], {'MCR', [char(uGroups(1)),' PV'],  [char(uGroups(2)),' PV']})
        xlabel('rate')
    end
else
    error('multi goup output not yet supported')
end


return