function clID = fromFile(g, fName)
fid = fopen(fName, 'rt');
if fid == -1
    error(['Could not open: ', fName]);
end

hdrLine{1} = 'Row';
hdrLine{2} = 'Col';
hdrLine{3} = 'ID';
hdrLine{4} = 'Xoff';
hdrLine{5} = 'Yoff';
clLine(i,:) = strread(fgetl(fid), '%u%u%s%d%d', 'delimiter', '\t');



i = 1;
while(l)
    strLine = fgetl(fid);
    if strLine == -1
        break;
    end
    clLine  = strread(strLine, '%s', 'delimiter', '\t');
    i =  i + 1;
end
    
