function showResults(folder)
global ShowGraphicalOutput
runDataFile = fullfile(folder, 'classPredictRunData.mat');
if exist(runDataFile, 'file');
    runData = load(runDataFile);
else
    return
end
%% text output to file
fname = [datestr(now,30),'PredictionResults.xls'];
fpath = fullfile(folder, fname);
fid = fopen(fpath, 'w');
if fid == -1
    error('Unable to open file for writing results')
end
try
    runData.cr.print(fid);
    fclose(fid);
    eval(['!open "',folder,'"']);
catch
    fclose(fid);
    error(lasterr)
end

%% Graph output
if isequal(ShowGraphicalOutput, 'yes')
    % PamIndex plot if apllicable 
    if length(runData.cr.models(1).uGroup) == 2 && ~isempty(runData.cr.group)
        figure
        runData.cr.pamIndex;
        set(gcf, 'Name', 'Predictions')
    end
end


