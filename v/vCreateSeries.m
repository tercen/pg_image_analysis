function T = vCreateSeries(v, sMeasurement, sSeriesAnnotation, clDisAnnotation, varargin)

if nargin > 4
    %iSkip   = strmatch('Skip', varargin);
    clSkip  = varargin(2);
end


vNames = fieldnames(v);

xSeries = ['x_',sSeriesAnnotation];
ySeries = ['y_',sMeasurement];
bNormalizer = isfield(v, 'Normalizer');
T(1).strDisAnnotation = [];
T(1).(xSeries) = [];
T(1).(ySeries) = [];
T(1).QcFlag  = [];

clExistingAnnotation = [];
for i=1:length(v)
    iSkip = strmatch(v(i).ID(1:3), clSkip);
    if isempty(iSkip)
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

        if isempty(iMatch)
            nSeries = length(T);

            T(nSeries+1).strDisAnnotation = strDisAnnotation;
            T(nSeries+1).(xSeries)=v(i).(sSeriesAnnotation);
            T(nSeries+1).(ySeries)=v(i).(sMeasurement);
            T(nSeries+1).QcFlag   =v(i).QcFlag;
            T(nSeries+1).primaryR2 = v(i).R2;
        else
            % add to exisiting entry

            nPoints = length(T(iMatch).(xSeries));
            T(iMatch).(xSeries)(nPoints+1) = v(i).(sSeriesAnnotation);
            T(iMatch).(ySeries)(nPoints+1) = v(i).(sMeasurement);
            T(iMatch).QcFlag(nPoints+1)     = v(i).QcFlag;
            T(iMatch).primaryR2(nPoints+1) = v(i).R2;
        end
    end

end




 




        


    



