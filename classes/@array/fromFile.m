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
% Next to these required columns more columns can be added for user
% reference. array.fromFile will skip these.
% 
% OUT:
% oArrayOut will contain loaded row, col, isreference, xOffset, yOffset
%
% IN:
% oArray: array object as definde by oArray = array(args)
% filename: full path to the template file
% gridRefMarker (optional): code that precedes an ID in the file and
% signifies that the spot should be used a gridding reference. If the
% gridRefMarker is omitted or the specified gridRefMarker is not found in
% the template file all spots are used as gridRefMarkers.
%
% EXAMPLE:
% template file ('MyArray.txt')
% Row    Col ID      Xoff    Yoff   MyRef
% 1     1   SPOT1   0       0       mutation1
% 1     2   #ref    0       0       ref
% 2     1   #ref    0       0       ref
% 2     2   SPOT2   0       0       mutation1
% 
% oArray = array();
% % oArray = fromFile(oArray, 'MyArray.txt', '#');
% r = get(oArray, 'row')
% 
% r =
% 
%      1
%      1
%      2
%      2
% >> b = get(oArray, 'isreference')
% 
% b =
% 
%      0
%      1
%      1
%      0
% 
% % and >> b = get(oArray, 'isreference')
% 
% b =
% 
%      1
%      1
%      1
%      1
% 
%  >> ID = get(oArray, 'ID')
% 
% ID = 
% 
%     'SPOT1'
%     '#ref'
%     '#ref'
%     'SPOT2'
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

