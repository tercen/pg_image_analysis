function series = vCreateSeries(v, sMeasurement, sSeriesAnnotation, clDisAnnotation, clInclude, varargin)


bNormalizer = 0;
bNegative = 0;
if nargin > 5
    iNormalize = strmatch('Normalize', varargin, 'exact');
    if ~isempty(iNormalize)
        strNormalizer = varargin{iNormalize(1)+1};
        bNormalizer = isfield(v, strNormalizer);
    end
    iNegative = strmatch('Negative', varargin, 'exact');
    if ~isempty(iNegative)
        strNegative = varargin{iNegative(1)+ 1};
        bNegative = isfield(v, strNegative);
    end

end

n = 0;
c = 0;
for i=1:length(v)
    iIncl = strmatch(v(i).ID(1:3), clInclude);
    if ~isempty(iIncl)
        clear clAnnotation
        strID = v(i).ID;
        iCoord = findstr(strID, '_(');
        strID = strID(1:iCoord-1);
        
        strAnnotation = [v(i).ID];
        for j=1:length(clDisAnnotation)
            strAnnotation = [strAnnotation,'_',v(i).(clDisAnnotation{j})];
            clAnnotation(j) = cellstr(v(i).(clDisAnnotation{j}));
        end
        clAnnotation{end+1} = strID;
        if bNormalizer
            M = v(i).(strNormalizer);
        else
            M = [];
        end
        if bNegative
            N = v(i).(strNegative);
        else
            N = [];
        end
        d = dataPoint(v(i).(sSeriesAnnotation), v(i).(sMeasurement), M, N, v(i).R2, v(i).sSig, v(i).aChiSqr, v(i).localT, v(i).localCV);
        if isempty(findstr(strAnnotation, '#'))
            n = n+1;
            % no # special character



            if n == 1
                series = annotatedSeries(clAnnotation);

                series = addDataPoint(series, d);
                annotations{1} = strAnnotation;
            else
               
                iMatch = strmatch(strAnnotation, annotations, 'exact');

                if ~isempty(iMatch)
                     series(iMatch) = addDataPoint(series(iMatch),d);
                else
                    series(end+1) = annotatedSeries(clAnnotation);
                    series(end) = addDataPoint(series(end), d);
                    annotations{end+1} = strAnnotation;
                end
            end
        else
            % did find a# , so check if control
            iMatch = strmatch('#control', clAnnotation);
            if ~isempty(iMatch)
                % put controlls on stack for now
                c =c+1;
                control(c).cp = d;
                control(c).annotation= clAnnotation;
            end
        end
    end
end

% go trough control stack and add the controlls to the appropriate series
if c>0
    for i=1:length(control)
        iHekje = strmatch('#', control(i).annotation);
        for j = 1:length(series)
            sAnnotation = get(series(j), 'annotation');
            l = zeros(length(control(i).annotation),1);
            for k=1:length(control(i).annotation)
                if isequal(control(i).annotation{k}, sAnnotation{k}) | k == iHekje
                    l(k) = 1;
                end
            end
            if l

                series(j) = addDataPoint(series(j),control(i).cp);
            end
        end
    end

end

    


end

