sDir        = uigetdir('C:\temp', 'Select Data Directory')
sConfig     = 'G:\DataAnalysis\DatConfigurations\PS96DftKinetics.ini';
[sTemplate, sPath]   = uigetfile('G:\DataAnalysis\Bin\*.tpl', 'Select imagene template')
sBatch = 'G:\DataAnalysis\Bin\nBatch.bch';

if isstr(sDir)  & isstr(sTemplate)
    t0 = clock;
    cDir = pwd;
    sTemplate = [sPath,'\',sTemplate];
    cd('G:\DataAnalysis\MatlabCompiled4\imgSetupBatch');
    str = ['!imgSetupBatch "',sDir,'" "',sConfig,'" "',sTemplate,'" "',sBatch,'"']
    eval(str);
    etime(clock, t0)
    cd('C:\ImagenePG');
    str = ['!Imagene5 -batch "',sBatch,'"']
    eval(str);
    cd('G:\DataAnalysis\MatlabCompiled4\imgCollectResults');
    str = ['!imgCollectResults "',sBatch,'" "',sDir,'"']
    eval(str)
    cd(cDir)
end
    
