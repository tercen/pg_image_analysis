% %fd10test
sData = 'D:\temp\data\PS4\BMPO_RPE(LS) 5 auto (06012005)-run 08-13 12-Jan-2005_C2';
sSettings = 'C:\PamSoft\Evolve\DataAnalysis\Bin\FD10mEndPoint.ini';
sTemplate = 'G:\DataAnalysis\Bin\PS4_SO0290FM.tpl';
sBatch = [sData,'\nbatch.bch'];
imgSetupBatch(sData, sSettings, sTemplate, sBatch);
curDir = pwd;
cd('C:\Imagene')
eval(['!Imagene5 -batch "',sBatch,'"']);
cd(curDir)
imgCollectResults(sBatch,sData, sSettings);