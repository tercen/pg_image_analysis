function [g,clID] = fromFile(g, fName, gridRefMarker)
if nargin == 2
    gridRefMarker = [];
end

fid = fopen(fName, 'rt');
if fid == -1
    error(['Could not open: ', fName]);
end

hdrLine{1} = 'Row';
hdrLine{2} = 'Col';
hdrLine{3} = 'ID';
hdrLine{4} = 'Xoff';
hdrLine{5} = 'Yoff';
fLine = strread(fgetl(fid), '%s', 'delimiter', '\t')';

% read in spot data 
n = 1;
while(1)
    strLine = fgetl(fid);
    if strLine == -1
        break;
    end
    if ~isempty(strLine)
        try
            [row(n), col(n), strID, xOff(n), yOff(n)]  = strread(strLine, '%f%f%s%f%f', 'delimiter', '\t');
        catch
            error(['Error reading template file: ', fName]);
        end
        ID(n) = cellstr(strID);
        n= n+ 1;

    end
end
fclose(fid);
% find grid references  (use gridRefMarker);
% and create mask;
if ~isempty(gridRefMarker)
    iMatch = strmatch(gridRefMarker, ID);
    mask = zeros(max(row), max(col));
    for n=1:length(iMatch)
        i = row(iMatch(n));
        j = col(iMatch(n));
        mask(i,j) = 1;
    end
else
    mask = ones(max(row), max(col));
end
g.mask = mask;
for i=1:length(ID)
    clID(row(i), col(i)) = ID(i);
end

% return ID's as well
% TO DO: position offsets
