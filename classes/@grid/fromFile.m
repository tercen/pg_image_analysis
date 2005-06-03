function clLine = fromFile(g, fName)
fid = fopen(fName, 'rt');
if fid == -1
    error(['Could not open: ', fName]);
end

hdrLine{1} = 'Row';
hdrLine{2} = 'Col';
hdrLine{3} = 'ID';
hdrLine{4} = 'Xoff';
hdrLine{5} = 'Yoff';
clLine = strread(fgetl(fid), '%s', 'delimiter', '\t')';
if ~isequal(clLine, hdrLine)
    warning([fName, ' is not a valid grid file']);
end



n = 1;
while(1)
    strLine = fgetl(fid);
    if strLine == -1
        break;
    end
    clLine(n,:)  = strread(strLine, '%d%d%s%d%d', 'delimiter', '\t');
    n= n+ 1;
end
    
