% %fd10test
sData = 'P:\140-0 series Tested Knowhow - FMT - BTS\140-080 Array preparation BTS module 2\041223-Niek\041223-Niek-ImageResults';
sSettings = 'C:\PamSoft\Evolve\DataAnalysis\Bin\FD10DftKinetics.ini';
sTemplate = 'G:\DataAnalysis\Bin\FD10 imagenetempl_MK050.tpl';
sBatch = [sData,'\ImageneBatch.bch'];
imgSetupBatch(sData, sSettings, sTemplate, sBatch);
% curDir = pwd;
% cd('C:\Imagene')
% eval(['!Imagene5 -batch "',sBatch,'"']);
% cd(curDir)
%imgCollectResults(sBatch,sData, sSettings);