%fd10test
sData = 'D:\temp\data\epTest\epTest-ImageResults';
sSettings = 'FD10mEndPoint.ini';
sTemplate = 'D:\temp\data\041110 FD10-2ref290expRW\reftpl.tpl';
sBatch = [sData,'\ImageneBatch.bch'];
imgSetupBatch(sData, sSettings, sTemplate, sBatch);
curDir = pwd;
cd('C:\Imagene')
eval(['!Imagene5 -batch "',sBatch,'"']);
cd(curDir)
imgCollectResults(sBatch,'D:\Temp\data\epTest', sSettings);