function [r,c] = fname2rc(fname, sInstrument);
% gets v file row and columns indices for fnames of known formats
% of .dat files for FD10 and PS96 (PS4)

if nargin < 2
    sInstrument = 'Detect';
end

fd10str = 'Testsite';
ps96RowStr = ['A';'B';'C';'D';'E';'F';'G';'H'];
ps96ColStr = ['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
r = [];
c = [];

if isequal(sInstrument, 'Detect')
    % check for the word testsite
    iMatch = findstr(fd10str, fname);
    
    % if testsite exists it is probably FD10
    if ~isempty(iMatch)
        r = fname(1:iMatch-2);
        c = fname(iMatch + length(fd10str));
    else
        % PS96?
        iW = findstr('W',fname); 
        if isempty(iW)
            iW = 0;
        end
        r = strmatch(fname(iW+1), ps96RowStr);
        c = strmatch(fname(iW+2:iW+3), ps96ColStr);
    end
elseif isequal(sInstrument, 'FD10')
    iMatch = findstr(fd10str, fname);
    if ~isempty(iMatch)
        r = fname(1:iMatch-2);
        c = fname(iMatch + length(fd10str));
    end
elseif isequal(sInstrument, 'PS96')
        iW = findstr('W',fname); 
        if isempty(iW)
            iW = 0;
        end
        r = strmatch(fname(iW+1)       , ps96RowStr);
        c = strmatch(fname(iW+2:iW+3)  , ps96ColStr);
end
   

   

    


