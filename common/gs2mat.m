function [data, spotID, annFields, annotations] = gs2mat(fName)
% function [data, spotID, annFields, annotations, title] = gs2mat(fName);
% where fName is a tab delimited textfile in GeneSprimg format.
fid = fopen(fName, 'rt');
% first read the title line:

sLine = fgetl(fid);
% first read in the title line
if ~ischar(sLine)
    fclose(fid);
    error([fName, ' is empty']);
end
% check if it looks like a title line
clLine = strread(sLine, '%s', 'delimiter', '\t');
if length(clLine) > 1
    bEmpty = strcmpi(sLine, '');
    if any(~bEmpty(2:end))
        fclose(fid);
        error(['Error reading ',fName,'. No title line recognized']);
    end
end
data = [];
spotID = {};
annFields = {};
annotations = {};
nSpots = 0;
while(1)
    sLine = fgetl(fid);
    clLine = strread(sLine, '%s', 'delimiter', '\t');
    if ~ischar(sLine)
        break;
    end
    
    if ~isempty(regexp(clLine{1}, '\()')) || ~isempty(regexp(clLine{1}, '\(+\w+\)+'))
       % read in annotation line
        
        annFields{end + 1} = clLine{1};
        for i=2:length(clLine)
            sVal  = clLine{i};
            val = str2num(sVal);
            if isempty(val) || ~isreal(val)
                val = sVal;
            end
            annotations{length(annFields), i-1} = val;
        end
    else
        nSpots = nSpots + 1;
        id = clLine(1);
        if isempty(id{1})
            break;
        else
            spotID(nSpots) = id;
        end
        
        
        val = str2num(char(clLine(2:end)));
       data(nSpots,:) = val';
       
    end
end

fclose(fid);
