% %fd10test
sData = 'G:\Users\Rik\FD10Renaming\Ying3\Ying3-ImageResults';
sSettings = 'FD10mEndPoint.ini';
sTemplate = 'G:\DataAnalysis\Bin\FD10GeTest.tpl';
sBatch = [sData,'\ImageneBatch.bch'];
% imgSetupBatch(sData, sSettings, sTemplate, sBatch);
% curDir = pwd;
% cd('C:\Imagene')
% eval(['!Imagene5 -batch "',sBatch,'"']);
% cd(curDir)
imgCollectResults(sBatch,sData, sSettings);