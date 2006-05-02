function series = sCreateSeries(v, spots, aGroup, aSeries, qType)

[clID{1:length(v)}] = deal(v.ID); 

% remove the intra well replicate info from the spot IDs

for i= 1:length(spots)
    iPosMarker =regexp(spots{i}, '\_(\d+:\d+\)');
    iPosMarker = iPosMarker(end);
    
    str = spots{i};
    spots{i} = str(1:iPosMarker-1);
end
spots = clGetUniqueID(spots);
series = struct([]);
for n=1:length(spots)
    % run trought the list of spots and axtract the v-file entries
    % that correspond to required spots.

    iThisSpot = strncmp(spots{n}, clID, length(spots{n}) );
    vThisSpot = v(iThisSpot);
    
    % now run trough the extracted entries and create series according to
    % selected annotations.
    exAnnotation = cellstr('');
    nSeries = 0;
    for m = 1:length(vThisSpot)
        strAnn = [];
        % create an annotation string for the current entrie
        for g = 1:length(aGroup)
            strAnn = [strAnn, '_', vThisSpot(m).(aGroup{g})];
        end
        % check if the annotation string already exists
        iMatch = strmatch(strAnn, exAnnotation);
        if isempty(iMatch)
            % if not create a new series
            nSeries = nSeries+ 1;
            s(nSeries).spotID = spots{n};
            s(nSeries).annotation = strAnn;
            s(nSeries).x = [];
            s(nSeries).y = [];
            s(nSeries).qcFlag = [];
            iMatch = nSeries;
        end
        % add entry to the existing or newly created annotation
        s(iMatch).x(end+1) = vThisSpot(m).(aSeries);
        
        if isfield(vThisSpot, 'M');
           % normalize if required
            M = vThisSpot(m).M;
        else
           M = 1;
        end
        s(iMatch).y(end+1) = vThisSpot(m).(qType) * M;
        s(iMatch).qcFlag(end+1) = vThisSpot(m).QcFlag;
        % update the existing annotation list. 
        [exAnnotation{1:length(s)}] = deal(s.annotation);
    end
    series = [series;s'];
    clear s
end

          
                
            
    
    
    
    