%% sFit
% matlab scripts for secondary fitting (IC50 etc.) using a v-file and an
% annotation file.
%
% uses:
% C:\PamSoft\DataAnalysis\common
% C:\PamSoft\DataAnalysis\v
% C:\PamSoft\DataAnalysis\classes

clear all
close all

%% User Settings
% 1. Use (true) or don't use (false) the v-file flags
autoOutlier = true;
% 2. Use (true) or don't use (false) manual outlier detection before
% fitting:
manOutlier = true;
% 3. Quantitation type used for substrates:
qType = 'Vini';


%% Load ini file
iniFile = 'sFit.ini';
iniPars.vPath = pwd;
iniPars.aPath = pwd;
iniPars = getparsfromfile(iniFile, iniPars);
%% Select and Read v-file
disp('Select v-file');
[vName, vPath] = uigetfile('*.v', 'Select v-file', iniPars.vPath);
if ~ischar(vName)
    return;
end
iniPars.vPath = vPath;
disp('loading v-file ...');
[v, msg] = vLoad([vPath, '\', vName]);
if ~isempty(msg)
    error(msg);
end
%% Select and Read annotation file
disp('Select annotation file');
[aName, aPath] = uigetfile('*.txt', 'Select annotation file', iniPars.aPath);
if ~ischar(aName)
    return;
end
iniPars.aPath = aPath;
[v, annFields, msg] = vAnnotate96(v, [aPath, '\', aName]);
if ~isempty(msg)
    error(msg);
end

SetIniPars(iniFile, iniPars);
disp('annotation done using: ')
disp(annFields);

% Now we should have an annotated v-file
%% Select Spots, normalizers and annotations using the sFitSelector GUI
spotID = vGetUniqueID(v, 'ID');
h = sFitSelector(spotID, annFields);
waitfor(h, 'Visible');
handles = guidata(h); delete(h);
iNormalizer = handles.iNormalizer-1 ;
iSubstrate = handles.iSubstrates;
iGrouping = handles.iGrouping;
iSeries = handles.iSeries;
clear handles
%% Add normalizers to the v-structure, if required
if ~isempty(iNormalizer);
    disp('Normalizing using: ');
    disp(spotID(iNormalizer)');
    v = sAddNormalizer(v, spotID(iNormalizer));
    disp('Normalization done ...');
end
%% Select the fit model
% logIC50_4 is a good standard model for IC50s
disp('Select the fit model ...');
oP = pgFit('select');
oP = set(oP, 'fitMethod', 'Robust');
oF = get(oP, 'modelObj');

%% Create the secondary fit series
series = sCreateSeries(v, spotID(iSubstrate), annFields(iGrouping), char(annFields(iSeries)), qType);

%% If required run manual inspection, if required use qcFlags for outliers

for i=1:length(series)
    x = series(i).x;
    y = series(i).y;
    out = false(size(x));
    if autoOutlier
        iOut = find(series(i).qcFlag);
        out(iOut) = true;

    end


    if manOutlier
        w = ones(size(x));
        w(out) = 0;
        [pRes, pAse, w] = computeFit(oP,x,y, w);
        dx = abs( (max(x) - min(x))/25);
        xFit = [min(x):dx:max(x)];
        yFit = getCurve(oF, xFit, pRes);

        h = InOutGui(x, y, xFit, yFit, out);
        strTitle = [series(i).spotID,' : ', series(i).annotation];
        set(h, 'Name', strTitle)
        uiwait(h);
        try
            handles = guidata(h);
            out = handles.out;
        catch
            break;
        end
        
    end
    series(i).out = out;
end
if manOutlier
    delete(h);
end

%% publish the results
oP = set(oP, 'fitMethod', 'Normal');
mkdir(vPath, '_sFitReport_');
options.outputDir = [vPath,'\_sFitReport'];
options.format = 'html';
options.showCode = false;
publish('sFitReport.m', options); 


iPoint = findstr(vName, '.');
iPoint = iPoint(end);

fStr = [vPath,'\_sFitReport\sFitReport_', vName(1:iPoint),'.',options.format];
copyfile([vPath,'\_sFitReport\sFitReport.',options.format], fStr);
open(fStr)

close all
