function rName = fnReplaceExtension(FileName, nExt);
% rName = imgGetResultName(FileName, nExt)
% replaces ext of filename with nExt
iLastPoint = findstr(FileName,'.'); iLastPoint = iLastPoint(length(iLastPoint));

if isequal(nExt(1),'.')
    n = 1;
else
    n = 0;
end

rName = [FileName(1:iLastPoint-n), nExt];


