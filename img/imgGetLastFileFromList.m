function [clLastName, clNotRec] = imgGetLastFileFromList(clList, pathList, sInstrument)
clLastName = [];
clNotRec = [];
nNotRec = 0;
nRec = 0;
for i=1:length(clList)
    [dummy, dummy, dummy, strP] = imgReadWFTP(char(clList(i)), char(pathList(i)), sInstrument);
    if ~isempty(strP)
        nRec = nRec + 1;
        strP = char(strP);
        P(nRec) = str2num(strP(2:length(strP)));
        index(nRec) = i;
    else
        nNotRec = nNotRec + 1;
        clNotRec{nNotRec} = clList(i);
    end
end

if (nRec > 0)
    [Pmax, iMax] = max(P);
    clLastName = clList(index(iMax));
end