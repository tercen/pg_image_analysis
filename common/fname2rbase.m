function rBase = fname2rbase(fPath, sInstrument)
% rBase = fname2rbase(fName, sInstrument)
% converts full path of Imagene file to result file (base) name

if isequal(sInstrument, 'FD10')
    iSlash = findstr(fPath, '\');
    if  length(iSlash) < 3
        rBase = -1
        return
    end
    
    iSlash = iSlash(length(iSlash)-2:length(iSlash));
    sTestSite = fPath(iSlash(1)+1:iSlash(2)-1);
    sSample  = fPath(iSlash(2)+1:iSlash(3)-1);
    rBase = [sTestSite,'_',sSample];
end

if isequal(sInstrument, 'PS96')
    iSlash          = findstr(fPath, '\'); 
    iSlash = iSlash(length(iSlash));
    iUnderScore     = findstr(fPath,'_');
    iUnderScore     = iUnderScore(length(iUnderScore));
    if isempty(iSlash) | isempty(iUnderScore)
        rBase = -1;
        return
    end
    rBase = fPath(iSlash+1:iUnderScore-1); 
end

if isequal(sInstrument, 'PS4')
    iSlash          = findstr(fPath, '\'); 
    iSlash = iSlash(length(iSlash));
    iUnderScore     = findstr(fPath,'_');
    iUnderScore     = iUnderScore(length(iUnderScore));
    if isempty(iSlash) | isempty(iUnderScore)
        rBase = -1;
        return
    end
    rBase = fPath(iSlash+1:iUnderScore-1); 
end
