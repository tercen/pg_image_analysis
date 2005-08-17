function [a, msg] = vReadAnnotation(aFile)
a = [];
msg = [];
fid = fopen(aFile, 'rt');
if (fid == -1)
    msg = ['vReadAnnotation: Could not open: ',msg];
    return
end

%read first line
sLine = fgetl(fid);
clHdr = strread(sLine, '%s', 'delimiter','\t');
n = 0;
while(1)
    sLine = fgetl(fid);
    n = n+1;
    if (sLine == -1)
        break;
    end
    clData = strread(sLine, '%s', 'delimiter', '\t');
    for i=1:length(clHdr)
        
        dVal = str2num(char(clData(i)));
        strField = char(clHdr(i));
        try
            if ~isempty(dVal)
                a(n).(strField) = dVal; 
            else
                a(n).(strField) = char(clData(i));
            end
        catch    
            ifStr = 'Invalid field name';
            if strncmp(ifStr, lasterr, length(ifStr))
                disp('Annotation field names cannot contain spaces or special symbols (@#+-& etc)'); 
                error(lasterr)
            end
                
        end
        

     end
end

    