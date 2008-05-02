function [T, C] = getImageInfo(fnames)

for i=1:length(fnames)
    sInfo(i) = pg_imtifinfo(fnames{i});
end
if isfield(sInfo, 'ExposureTime')
    [st{1:length(sInfo)}] = deal(sInfo.ExposureTime);
    if ~iscellstr(st)
        T = cell2mat(st);
    else
        T = str2num(char(st));
    end
    
else
    T = [];
end

if isfield(sInfo, 'Cycle')
   
    [sc{1:length(sInfo)}] = deal(sInfo.Cycle);
    
    if ~iscellstr(sc)
        C = cell2mat(sc);
    else
        C = str2num(char(sc));
    end
    
else
    C = [];
end

