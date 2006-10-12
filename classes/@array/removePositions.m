function oArray = removePositions(oArray, bRemove)

if isequal(bRemove, 'isreference')
    bKeep = ~oArray.isreference;
elseif  isequal(bRemove, '~isreference')
    bKeep = oArray.isreference;
elseif islogical(bRemove)
    bKeep = ~bRemove;
else
    error('invalid value for bRemove')
end

oArray.isreference = oArray.isreference(bKeep);
oArray.row = oArray.row(bKeep);
oArray.col = oArray.col(bKeep);
oArray.xOffset = oArray.xOffset(bKeep);
oArray.yOffset = oArray.yOffset(bKeep);
oArray.ID = oArray.ID(bKeep);

    