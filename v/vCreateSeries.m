function T = vCreateSeries(v, sMeasurement, sSeriesAnnotation, clDisAnnotation, clInclude, varargin)

if nargin > 5
    iNormalize = strmatch('Normalize', varargin, 'exact')
    if ~isempty(iNormalize)
        strNormalizer = varargin{iNormalize(1)+1};
        bNormalizer = isfield(v, strNormalizer);
    end
    iNegative = strmatch('Negative', varargin, 'exact')
    if ~isempty(iNegative)
        strNegative = varargin{iNegative(1)+ 1};
        bNegative = isfield(v, strNegative);
    end
    
    iControl = strmatch('Control', varargin, 'exact');
    if ~isempty(iControl)
        strControl = varargin(iControl(1)+1);
        bControl = isfield(v, strControl);
end
end


vNames = fieldnames(v);

xSeries = ['x_',sSeriesAnnotation];
ySeries = ['y_',sMeasurement];

T(1).strDisAnnotation = [];
T(1).(xSeries) = [];
T(1).(ySeries) = [];
T(1).QcFlag  = [];


clExistingAnnotation = [];

if bControl

end




for i=1:length(v)
    if bNormalizer
        M = v(i).(strNormalizer);
    else
        M = 1;
    end

    if bNegative
        N = v(i).(strNegative);
    else
        N = 0;
    end
    
    
        
    
    iInclude = strmatch(v(i).ID(1:3), clInclude);
    if ~isempty(iInclude)
        % create annotation string from annotations
        strDisAnnotation = [];
        for a = 1:length(clDisAnnotation)
            strField = clDisAnnotation{a};
            if ischar(v(i).(strField))
                strDisAnnotation = [strDisAnnotation,'_',v(i).(strField)];
            else
                strDisAnnotation = [strDisAnnotation,'_',num2str(v(i).(strField))];
            end
        end


        iUnderScore = findstr(v(i).ID, '_');
        strDisAnnotation = [strDisAnnotation,'_',v(i).ID(1:iUnderScore-1)];



        % check if annotation exists in T, if so ad v(i) to existing entry
        % otherwise create a new entry.
        if isempty(clExistingAnnotation)
            iMatch = 1;
            T(iMatch).strDisAnnotation = strDisAnnotation;
            clExistingAnnotation = cellstr(strDisAnnotation);
        else
            [clExistingAnnotation{1:length(T)}] = deal(T(:).strDisAnnotation);
            iMatch = strmatch(strDisAnnotation, clExistingAnnotation);
        end

        % this is the actual normalized and background corrected entry in
        % the series
        
        yPoint = M*(v(i).(sMeasurement) - N);

        if isempty(iMatch)
            nSeries = length(T);

            T(nSeries+1).strDisAnnotation   = strDisAnnotation;
            T(nSeries+1).(xSeries)          = v(i).(sSeriesAnnotation);
            T(nSeries+1).(ySeries)          = yPoint;
            T(nSeries+1).QcFlag             = v(i).QcFlag;
            T(nSeries+1).primaryR2          = v(i).R2;
            T(nSeries+1).sRelative          = v(i).sRelative;
        else
            % add to exisiting entry

            nPoints = length(T(iMatch).(xSeries));
            T(iMatch).(xSeries)(nPoints+1)  = v(i).(sSeriesAnnotation);
            T(iMatch).(ySeries)(nPoints+1)  = yPoint;
            T(iMatch).QcFlag(nPoints+1)     = v(i).QcFlag;
            T(iMatch).primaryR2(nPoints+1)  = v(i).R2;
            T(iMatch).sRelative(nPoints+1)   = v(i).sRelative;
        end



    end

end




 




        


    



