% %fd10test
sData = 'C:\temp\Aventis281204\Aventis281204-ImageResults';
sSettings = 'C:\PamSoft\Evolve\DataAnalysis\Bin\FD10mEndPoint.ini';
sTemplate = 'G:\DataAnalysis\Bin\FD10_SO0209FM.tpl';
sBatch = ['C:\temp\Aventis281204\nBatch.bch'];
%imgSetupBatch(sData, sSettings, sTemplate, sBatch);
 %curDir = pwd;
% cd('C:\Imagene')
% eval(['!Imagene5 -batch "',sBatch,'"']);
% cd(curDir)
imgCollectResults(sBatch,sData, sSettings);