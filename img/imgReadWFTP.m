    function [arrayID, filter, integrationTime, pumpCycle] = imgReadWFTP(baseName,pathName, sInstrument)
        
    arrayID = [];
    filter = [];
    integrationTime = [];
    pumpCycle   = [];

    % check if there's still an extension in basename:
    iPoint = findstr('.', baseName);
    % if so, remove everything after the first point
    if ~isempty(iPoint)
        baseName = baseName(1:iPoint(1)-1);
    end
    
    if isequal(sInstrument, 'PS96')
        % this assumes file naming in the format:
        % W[ArrayID]_F[filter]_T[integrationTime]_P[pumpCycle]
        a = strread(baseName, '%s', 'delimiter', '_');
        if length(a) < 4
            return
        end
        tArrayID = char(a(1));
        if tArrayID(1) ~= 'W';
            return
        end
        tFilter = char(a(2));
        if tFilter(1) ~= 'F';
            return
        end
        tIntegrationTime = char(a(3));
        if tIntegrationTime(1) ~= 'T';
            return
        end
        tPumpCycle = char(a(4));
        if tPumpCycle(1) ~= 'P';
            return
        end
        arrayID = a(1);
        filter = a(2);
        integrationTime = a(3);
        pumpCycle = a(4);
    end
    
    if isequal(sInstrument, 'FD10')
        % this assumes:
        % xxxxTestsiteN_P.tif;
        a = strread(baseName, '%s', 'delimiter', '_');
        if (length(a) ~= 2)
            return
        end
        arrayID     = a(1);
        pumpCycle   = a(2);
        
        sPathName = char(pathName);
        iSlash = findstr(sPathName,'\');
        iSlash = iSlash(length(iSlash));
        integrationTime = cellstr(sPathName(iSlash+1:length(sPathName)));
        filter  = 'F1';   
    end
    