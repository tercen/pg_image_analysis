function [data, spotID, annValues, annFields] = genespring2mat(fname)
% function [data, spotID, annValues, annFields] = genespring2mat(fname)
% Rik de Wijn (c) 2005 PamGene International.
%
% reads in  "gene spring" file fname (qualified path)
% data: NxM double with data values, rows are the spots, cols the conditions 
% spotID: cell vector of string length N with entries the spot ID's corresponding to
% the rows of data
% annValues (K x M) cell array with annotation values (condition
% description), corresponding to the cols of data.
% annFields cell array (length K) with names for the annotation values in
% annValues
% Exampe:
% [data, spotID, annValues, annFields] = genespring2mat('SO-566C3GSEL.txt';
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
    if isempty(iCaption) && n>0 && ~isempty(clLine{1})
        % end of annotation reached
        break;
    elseif isempty(iCaption) && (n == 0 || isempty(clLine{1}))
        % hdr line:  just read in next line
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
    data(:,n) = cellfun(@cnvCellStr, clLine(2:end));   
    strLine = fgetl(fid);
end
data = data';
spotID = spotID';
annValues = annValues';
fclose(fid);

function num = cnvCellStr(cstr)
num  = str2double(cstr);
if isempty(num)
    num  = NaN;
end


    
    
        
        
    
