function g = fromFile(g, fName, gridRefMarker)
% array.fromFile
% [oArrayOut, clID] = fromFile(oArray, filename, <gridRefMarker>)
% read array object form file
% This method can be used to read in mask and spot ID's for a tab delimited
% textfile filename (ie a template file).
% The text file should contain the following columns:
% Row: row of a spot in the array
% Col: columns of spot in the array
% ID: spot ID
% Xoff: offset from ideal in pixels
% Yoff: offset from ideal in pixels
% OUT:
% oArrayOut will contain updated mask
% clID, (nRows, nCol) cell array of strings containing the spot IDs
% IN:
% oArray: array object as definde by oArray = array(args)
% filename: full path to the template file
% gridRefMarker (optional): code that precedes an ID in the file and
% signifies that the spot should be used a gridding reference. If the
% gridRefMarker is omitted or the specified gridRefMarker is not found in
% the template file all spots are used as gridRefMarkers.
%
% EXAMPLE:
% template file ('temp.txt')
% Row    Col ID      Xoff    Yoff
% 1     1   SPOT1   0       0
% 1     2   #ref    0       0 
% 2     1   #ref    0       0
% 2     2   SPOT2   0       0
% 
% oArray = array();
% [oArray, clID] = fromFile(oArray, 'temp.txt', '#');
% mask = get(oArray, 'mask');
% results in:
% mask = [0 1
%         1 0 ]
% clID = ['SPOT1'  '#ref' 
%          '#ref'    'SPOT2']
%
% and oArray = fromFile(oArray, 'temp.txt')
% mask = get(oArray, 'mask')
% results in:
% mask = [1 1
%         1 1];
%
% See also array/array, array/gridFind
if nargin == 2
    gridRefMarker = [];
end

fid = fopen(fName, 'rt');
if fid == -1
    error(['Could not open: ', fName]);
end

% define columnheader keywords that identify the required columns in the
% file:

clHdrKeyWord{1} = 'Row';
clHdrKeyWord{2} = 'Col';
clHdrKeyWord{3} = 'ID';
clHdrKeyWord{4} = 'Xoff';
clHdrKeyWord{5} = 'Yoff';

% read the header line into cell array
fLine = strread(fgetl(fid), '%s', 'delimiter', '\t')';
%identfy columns nrs corresponding to keyword.
% error return when any of the keywords is not matched exactly one time:
for i = 1:length(clHdrKeyWord)
    iMatch = strmatch(clHdrKeyWord{i}, fLine);
    if length(iMatch) ~= 1
        error(['Error reading: ', fName,'. Cannot uniquely identify column header: ',clHdrKeyWord{i}]);
    else
        keyMatch(i) = iMatch;
    end
end

% read in spot data 
n = 1;
while(1)
    strLine = fgetl(fid);
    
    if strLine == -1
        break;
    end
    strLine = deblank(strLine);
    if ~isempty(strLine)
        try
            % read into cell array.
            clLine = strread(strLine,'%s', 'delimiter', '\t');
            % get row, col, ID, xOff, yOff according to clHdrKeyWord
            % (keyMatch).
            % convert to numerics if appropriate
            row(n)     = str2num(char((clLine(keyMatch(1)))));
            col(n)     = str2num(char((clLine(keyMatch(2)))));
            ID(n)      = clLine(keyMatch(3));
            xOff(n)    = str2num(char((clLine(keyMatch(4)))));
            yOff(n)    = str2num(char((clLine(keyMatch(5)))));
           
            %[row(n), col(n), strID, xOff(n), yOff(n)]  = strread(strLine, '%f%f%s%f%f', 'delimiter', '\t');                        
        catch
            eStr = [lasterr,' On line ',num2str(n),': ',strLine];
            error(eStr, 'error reading template file');
        end
         n= n+ 1; 

    end
end
fclose(fid);
% find grid references  (use gridRefMarker);
if ~isempty(gridRefMarker)
    isreference = strncmp(gridRefMarker, ID, length(gridRefMarker));
    if ~any(isreference)
        % if no grdRefMarker set all true;
        isreference = true(size(ID));
    end
else
    % if no ref specified set all true;
    isreference = true(size(ID));
end

g.row = row';
g.col = col';
g.isreference = isreference';
g.ID = ID';
g.xOffset = xOff';
g.yOffset = yOff';

% and create mask;
% if ~isempty(gridRefMarker)
%     iMatch = strmatch(gridRefMarker, ID);
%     if ~isempty(iMatch)
%         mask = zeros(max(row), max(col));
%         for n=1:length(iMatch)
%             i = row(iMatch(n));
%             j = col(iMatch(n));
%             mask(i,j) = 1;
%         end
%     else
%         mask = ones(max(row), max(col));
%     end
% else
%     mask = ones(max(row), max(col));
% end
% g.mask = mask;
% for i=1:length(ID)
%     clID(row(i), col(i)) = ID(i);
%     g.xOffset(row(i), col(i)) = xOff(i);
%     g.yOffset(row(i), col(i)) = yOff(i);
% end
% % return ID's as well

