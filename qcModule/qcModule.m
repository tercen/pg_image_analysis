function qcModule(vFile, settingsFile)
% Module for qc of v-file
% 
global MSGOUT
MSGOUT = 1;
iniPars.qcMethod = '';
[iniPars, fid] = getparsfromfile(settingsFile, iniPars);
if (fid == -1)
    fprintf(MSGOUT, 'qcModule cannot open ini file: %s',settingsFile);
    eCode = 0;
    fprintf(MSGOUT, 'Exit Code: %d',eCode);
    return
end
v = vLoad(vFile);
if isempty(v);
    fprintf(MSGOUT, 'qcModule could not load v-file: %s', vFile);
    eCode = 0;
    fprintf(MSGOUT, 'Exit Code: %d', eCode);
    return
end

eCode = 1;
if isequal(iniPars.qcMethod, 'Kinase')
    [vOut, eCode] = qcKinase(v, settingsFile);
else
    fprintf(MSGOUT, 'Unknown QC method: %s',iniPars.qcMethod);
    eCode = 0;
    fprintf(MSGOUT, 'Exit Code: %d',eCode);
    return
end
fprintf(MSGOUT, 'Exit Code: %d', eCode);