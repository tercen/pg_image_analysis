function stFunctions = cfGetPPFunctions(fname);
fid = fopen(fname,'rt');
if fid == -1
    stModels = [];
    uiwait(errordlg(['Could not open function file: ', fname, '! Press OK to terminate'],'img Error'));
    return;
end
i = 0;
while(1)
    line = fgetl(fid);
    if (line == -1)
        break;
    end
    if isequal(line, '<Function>')
        i = i+1;
        pRead = 0;
        for n = 1:3
            line = fgetl(fid);
            clLine = strread(line, '%s', 'delimiter', '>');
            switch char(clLine(1))
                case 'ppName'
                    stFunctions(i).ppName= char(clLine(2));
                    pRead = pRead + 1;    
                case 'ppFunction'
                    stFunctions(i).ppFunction = char(clLine(2));
                    pRead = pRead + 1;    
                case 'ppParVals'
                    for j=2:length(clLine)
                        stFunctions(i).ppParVals(j-1) = clLine(j);
                    end
                pRead = pRead + 1;        
                    
            end
        end    
        if (pRead < 3)
            error(['error reading: ', fname]);
        end 
        
    end
end
fclose(fid);
        