function [clHeaders, nSpots]  = imgScanFile(FileName);
% scans img file for headers and number of spots
    fid = fopen(FileName, 'rt');
    if (fid == -1)
        nSpots = -1;
        return
    end
    blDataLine = 0;
    nSpots = 0;
    while(1)
        line = fgetl(fid);
        if (line == -1)
            break;
        end
        
        
        if strcmp(line, 'End Raw Data')
            break;
        end
       
        if (blDataLine)
               nSpots = nSpots + 1;
        end    
        
        if strcmp(line,'Begin Raw Data')
            line = fgetl(fid);
            clHeaders = strread(line, '%s', 'delimiter','\t');
            blDataLine =1;
        end    
        
        
    end    
    fclose(fid);