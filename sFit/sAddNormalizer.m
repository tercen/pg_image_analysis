function v = sAddNormalizer(v, clID)
% create a plate overview with normalizers
nMaps = vArrange(v, 'ID', clID, 'EndLevel');
[s1,s2,s3] = size(nMaps);
for i=1:s3
    nor = nMaps(:,:,i);
 
    nor = mean(nor(~isnan(nor)));
    nMaps(:,:,i) = nMaps(:,:,i)/nor;
end
nMaps = mean(nMaps,3);
% add nromalizer to the v structure.
for i = 1:length(v)
     v(i).M = 1/nMaps(v(i).Index1, v(i).Index2); 
end
