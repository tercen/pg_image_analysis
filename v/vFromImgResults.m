function v = vFromImgResults(imgResFile, clRequestedHdr)
% v = vFromImgResults(imgResFile, clRequestedHdr)
[clHdr, nSpots] = imgScanFile(imgResFile);
nCols = length(clHdr);
clData = imgReadFile(imgResFile, nSpots, nCols);
for i=1:length(clRequestedHdr)
    iMatch = strmatch(clRequestedHdr{i}, clHdr);
    for j=1:nSpots
        strData = clData{j, iMatch};
        strField = clRequestedHdr{i};
        iSpace = findstr(strField, ' ');
        strField(iSpace) = '_';
        numData     = str2num(strData);
        if isempty(numData)
            v(j).(strField) = strData;
        else
            v(j).(strField) = numData;
        end
    end
end

            

