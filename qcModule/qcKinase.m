function [vOut, eCode] = qcKinase(v, settingsFile)
vOut = [];
eCode = 1;
iniPars.refID = '';
iniPars.maxSigmaFacRef = 4;
iniPars.epsRef = 0.01;

iniPars = getparsfromfile(settingsFile, iniPars);



uniqueID    = vGetUniqueID(v, 'ID');
refID       = strmatch(iniPars.refID, uniqueID);
% do the ref spot statistics:
% for now put all refspots on a single large stack
refMaps = vAverage96(v, 'ID', refID, 'EndLevel');
[s1,s2,s3] = size(refMaps);
ref = reshape(s1*s2*s3,1);
[iOut, wSigma] = findOutliersRW(ref, iniPars.maxSigmaRef, iniPars.epsRef);






for i=1:length(v)
    