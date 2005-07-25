function v = vNormalize(v, strNormalizerID, maxSigmaFactor, maxFlagged)
clUniqueID = vGetUniqueID(v, 'ID');
iNormalizer = strmatch(strNormalizerID, clUniqueID);
refMaps = vArrange(v, 'ID', clUniqueID(iNormalizer), 'EndLevel');
[s1,s2,s3] = size(refMaps);
refCols = reshape(refMaps,s1*s2, s3);

for i=1:s3
    iNan = isnan(refCols(:,i));
    meanRefs(i) = mean(refCols(~iNan,i));
    refMaps(:,:,i) = refMaps(:,:,i)/meanRefs(i);
end
mRefMaps = mean(refMaps, 3);



if nargin > 2
    refCol =  reshape(refMaps, s1*s2*s3, 1);
    [mOut, wSigma] = findOutliersRW(refCol, 1, 0.01);
    
    mRef = mean(refCol(find(~mOut)));
end    

badNormalizer = '00000101';
for i=1:length(v)
   
    v(i).Normalizer  = 1/mRefMaps(v(i).Index1, v(i).Index2);
    if nargin > 2
        if abs(v(i).Normalizer - mRef) > wSigma*maxSigmaFactor
            v(i).QcFlag = bin2dec(badNormalizer);
        end
    end
end

if nargin > 2
    qcMap = vArrange96(v, 'ID', clUniqueID(iNormalizer), 'QcFlag','Average');
    [iBadWell, jBadWell] = find(qcMap > maxFlagged * bin2dec(badNormalizer));
    for i=1:length(v)
        for j=1:length(iBadWell)
            if v(i).Index1 == iBadWell(j) & v(i).Index2 == jBadWell(j)
                strFlag = dec2bin(v(i).QcFlag);
                strFlag(length(strFlag))    = '1';
                strFlag(length(strFlag-1))  = '1';
                v(i).QcFlag = bin2dec(strFlag);
            end
        end
    end
end

