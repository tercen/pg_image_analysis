function createBatchFile(batchID)
global pathImageResults;
global pathTemplate;
global pathConfiguration;
global imageFilter;
global instrument;
global gridMode;
global lPreprocess
global ppSmallDisk;
global ppLargeDisk;
global ppDiameter;
global ppBlurr;
global log;
global batchFile

if nargin == 0
    batchID = '';
end

try
    b = imgBatch();
    b = set(b, 'batchID', batchID);
    
   % check if the optional globals have been set otherwise refer to imgBatch object dfts.
    if isempty(imageFilter)
        imageFilter = get(b, 'imageFilter');
    end
    
    if isempty(log)
        log = 0;
    elseif ischar(log)
            fid = fopen(log, 'wt');
            set(b, 'log', fid);
    end
    
    if isempty(lPreprocess)
        lPreprocess = 0;
    end
    
    if (lPreprocess)
        p = preProcess();
        
        % check if the optional globals have been set otherwise refer to
        % preProcess dft object
        
        if isempty(ppSmallDisk)
            ppSmallDisk = get(p, 'nSmallDisk');
        end
        if isempty(ppLargeDisk)
            ppLargeDisk = get(p, 'nLargeDisk');
        end
        if isempty(ppDiameter)
            ppDiameter  = get(p, 'nCircle');
        end
        if isempty(ppBlurr)
            ppBlurr = get(p, 'nBlurr');
        end
           
        p = set(p,  'nSmallDisk',ppSmallDisk, ...
            'nLargeDisk',ppLargeDisk, ...
            'nCircle', ppDiameter, ...
            'nBlurr', ppBlurr);  
    else
        p = [];
    end
      
    b = set(b, 'pathImageResults'   , pathImageResults, ...
        'pathTemplate'       , pathTemplate, ...
        'pathConfiguration'  , pathConfiguration, ...
        'imageFilter'        , imageFilter, ...
        'instrument'         , instrument, ...
        'gridMode'           , gridMode, ...
        'ppObj'              , p, ...
        'log'                , log);

    batchFile = batchCreate(b);
catch
    % error handling ????
    errmsg = lasterr;
    uiwait(errordlg(errmsg));
    bFile = 'NULL';
end

    
               