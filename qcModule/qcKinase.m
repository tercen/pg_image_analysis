function [vOut, eCode] = qcKinase(v, settingsFile)
vOut = [];
eCode = 1;
iniPars.refID = '';
iniPars = getparsfromfile(settingsFile, iniPars);
uniqueID    = vGetUniqueID(v, 'ID');
refID       = strmatch(iniPars.refID, uniqueID);
