function [data, spotID, annValues, annFields] = genespring2mat(fname)
fid = fopen(fname, 'rt');
if fid == -1
    error(['Error reading ',fname]);
end

% first read in the annotation
n= 0;
while(true)
    strLine = fgetl(fid);
    if strLine == -1
        error(['File ended before spot data was found.']);
    end
    
    clLine = strread(strLine, '%s', 'delimiter', '\t');
    iCaption = regexp(clLine{1}, '\()');
    if isempty(iCaption) && n>0
        % end of annotation reached
        break;
    elseif isempty(iCaption) && n == 0
        % hdr line just read in next line
    else
        n = n+1;
        % read in annotation line
        annFields(n) = clLine(1);
        annValues(:,n) = clLine(2:end)';
        
    end
end
% now continue to read in spot data, note that the first data line was
% already read!
n = 0;
while(true)
    
    if strLine == -1
        % EOF
        break;
    end
    clLine = strread(strLine, '%s', 'delimiter', '\t');
    if isempty(clLine{1})
        break;
    end
    n = n+1;
    spotID(n) = clLine(1);
    data(:,n)  = str2num(char(clLine(2:end)));
    
    strLine = fgetl(fid);
end
data = data';
fclose(fid);

        
    
        
        
    
