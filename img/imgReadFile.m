function [clData, n] = imgReadFile(FileName, nSpots, nCols);
    clData = cell(nSpots, nCols);
    fid = fopen(FileName, 'rt');
    if (fid == -1)
        n = -1;
        return
    end
    blDataLine = 0;
    n = 1;
    while(1)
        line = fgetl(fid);
        if (line == -1)
            break;
        end
        
        if strcmp(line, 'End Raw Data')
            break;
        end
        
        if (blDataLine)
            clData(n,:) = strread(line, '%s', 'delimiter','\t');
            n = n+1;    
        end
        if strcmp(line,'Begin Raw Data')
            blDataLine = 1;  
            fgetl(fid);
        end
    end
   fclose(fid);
  n = n-1;
           
