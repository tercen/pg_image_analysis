sDir        = uigetdir('C:\temp', 'Select Data Directory')
sConfig     = 'G:\DataAnalysis\Bin\daConfigNormal.ini';
%[sTemplate, sPath]   = uigetfile('G:\DataAnalysis\Bin\*.tpl', 'Select imagene template')
sTemplate = 'G:\DataAnalysis\Bin\MK022_ii.tpl'
sBatch = 'G:\DataAnalysis\Bin\nBatch.bch';

cDir = pwd;
if isstr(sDir)  & isstr(sTemplate)
	cd('G:\DataAnalysis\MatlabCompiled4\imgSetupBatch\')
    str = ['!imgSetupBatch.exe "',sDir,'" "',sConfig,'" "',sTemplate,'" "',sBatch,'"']    
    eval(str)
    %imgSetupBatch(sDir, sConfig, sTemplate, sBatch)
    cd('G:\DataAnalysis\MatlabCompiled4\imgCollectResults\')
    str = ['!imgCollectResults.exe "',sBatch,'" "',sDir,'"']
    eval(str)
    cd(cDir);
    %imgCollectResults(sBatch, sDir)
end
