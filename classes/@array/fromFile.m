function [g, extraHeaders, extraColumns] = fromFile(g, fName, gridRefMarker)
% array.fromFile
% [oArrayOut, otherHeaders] = fromFile(oArray, filename, <gridRefMarker>)
% read array object form file
% This method can be used to read in mask and spot ID's for a tab delimited
% textfile filename (ie a template file).
% The text file should contain the following columns:
% Row: row of a spot in the array
% Col: columns of spot in the array
% ID: spot ID
% Xoff: offset from ideal in pixels
% Yoff: offset from ideal in pixels
% Next to these required columns extra columns can be added for user
% reference
% 
% OUT:
% oArrayOut will contain loaded row, col, isreference, xOffset, yOffset
% extraHeaders: headers of the extra colums as a cell array (see above)
% extraColumns:extra colum,sn corresponding to extra headers, as a cell
% array
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

clHdrKeyWord{1} = 'Row'; bRequired(1) = true;
clHdrKeyWord{2} = 'Col'; bRequired(2) = true;
clHdrKeyWord{3} = 'ID' ; bRequired(3) = true; 
clHdrKeyWord{4} = 'Xoff'; bRequired(4) = true;
clHdrKeyWord{5} = 'Yoff'; bRequired(5) = true;
clHdrKeyWord{6} = 'xFixedPosition'; bRequired(6) = false;
clHdrKeyWord{7} = 'yFixedPosition'; bRequired(7) = false;

% read the header line into cell array
fLine = strread(fgetl(fid), '%s', 'delimiter', '\t')';
%identfy columns nrs corresponding to keyword.
% error return when any of the keywords is not matched exactly one time:
keyMatch = zeros(size(bRequired));
for i = 1:length(clHdrKeyWord)
    iMatch = find(strcmp(clHdrKeyWord{i}, fLine));
    if isempty(iMatch) && bRequired(i)
        error(['Error reading: ', fName,'. Cannot find required columns header: ', clHdrKeyWord{i}]);
    elseif length(iMatch) > 1
        error(['Error reading: ', fName,'. Cannot uniquely identify column header: ',clHdrKeyWord{i}]);
    elseif ~isempty(iMatch)
        keyMatch(i) = iMatch;
    end
end

% make a list of the none matched headers
bMatch = false(size(fLine));
bMatch(keyMatch(find(keyMatch))) = true;
extraHeaders = fLine(~bMatch);


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
            if keyMatch(6) && keyMatch(7)
                xFxd(n) = str2num(char((clLine(keyMatch(6)))));
                yFxd(n) = str2num(char((clLine(keyMatch(7)))));
            end
            extraColumns(n,:) = clLine(~bMatch);
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
if keyMatch(6) && keyMatch(7)
    g.xFixedPosition = xFxd';
    g.yFixedPosition = yFxd';
else
    g.xFixedPosition = zeros(size(row'));
    g.yFixedPosition = zeros(size(row'));
end

    


