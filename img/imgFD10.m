%fd10test
sData = 'D:\temp\FD10RenamingProject\experimentYing\experimentYing-ImageResults';
sSettings = 'FD10mEndPoint.ini';
sTemplate = 'G:\DataAnalysis\Bin\FD10GeTest.tpl';
sBatch = [sData,'\ImageneBatch.bch'];
imgSetupBatch(sData, sSettings, sTemplate, sBatch);
curDir = pwd;
cd('C:\Imagene')
eval(['!Imagene5 -batch "',sBatch,'"']);
cd(curDir)
imgCollectResults(sBatch,'D:\Temp\data\epTest', sSettings);