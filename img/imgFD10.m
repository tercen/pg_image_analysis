%fd10test
sData = 'C:\temp\041020_FD10-3_exp1_Abl+Pepkin020_4-difwash_DMe';
sSettings = 'FD10DftKinetics.ini';
sTemplate = 'G:\DataAnalysis\Bin\FD10_pepkin020_DMe.tpl';
sBatch = [sData,'\ImageneBatch.bch'];
imgSetupBatch(sData, sSettings, sTemplate, sBatch);
curDir = pwd;
cd('C:\Imagene')
eval(['!Imagene5 -batch "',sBatch,'"']);
cd(curDir)
imgCollectResults(sBatch,sData, sSettings);