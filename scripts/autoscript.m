clear all
close all


% enter strings that correspond to column names in annotation file
% discrimninating annotation:
clDisAnnotation{1} = 'kinase';
%clDisAnnotation{2} = 'C';

% series annotation:
seriesAnnotation = 'inhibitor';

% identify the measurement to be fitted:
meas = 'Vini';

%***************************************************

iniFile = 'AutoIC50.ini';
IniPars.initialDir = 'C:\';
IniPars = getparsfromfile(iniFile, IniPars);
[vName, vPath] = uigetfile('*.v', 'Select v-file', IniPars.initialDir);

if ischar(vName)
[aName, aPath] = uigetfile('*.txt', 'Select annotation file', vPath);
if ~ischar(aName)
    return
end
mkdir(vPath, '_AutoIC50');

options.outputDir = [vPath,'\_AutoIC50'];
options.format = 'html';
publish('autoIC50.m', options); 

close all
open([vPath,'\_AutoIC50\autoIC50.',options.format])

IniPars.initialDir = vPath;
SetIniPars(iniFile, IniPars);
end

