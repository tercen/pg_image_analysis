function vPlotSeries(T, hFigIn, strAnnotation, strFunction)
persistent hFigure;
hFigure = hFigIn;

if nargin < 3
    strAnnotation = [];
    strFunction = [];
elseif nargin < 4
    strFunction = [];
end

clFields = fieldnames(T);
for i = 1:length(clFields)
    strField = clFields{i};
    if isstruct(T.(strField))
           vPlotSeries(T.(strField), hFigure, [strAnnotation,'_',strField])
    else
        iXName  = strmatch('x', clFields);
        iYName  = strmatch('y', clFields);
        iQcFlag = strmatch('QcFlag', clFields);


        nPlots = length(get(hFigure, 'Children'));

        if (nPlots == 0)
            subplot(3,2,1)

        elseif (nPlots >= 6)
            hFigure = figure;
            subplot(3,2,1)
        else
            subplot(3,2,nPlots+1)
        end
        
        strQcFlag = clFields{iQcFlag};
        vQc = T.(strQcFlag);
        
        iNoFlag       = find(vQc == 0);
        iFlag     = find(vQc ~= 0);
        plot(T.(clFields{iXName})(iFlag), T.(clFields{iYName}) (iFlag), 'rx');
        hold on
        plot(T.(clFields{iXName})(iNoFlag), T.(clFields{iYName}) (iNoFlag), 'o');
        if ~isempty(strFunction)
            feval(strFunction, gca, T)
        end
        
        title(strAnnotation, 'interpreter', 'none')
        drawnow;
        break;

    end

end
