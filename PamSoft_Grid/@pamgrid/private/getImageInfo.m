function [T, C] = getImageInfo(fnames)
% make sure that the correct iminfo file is set.
strInfo = 'pg_imtifinfo.m';
f = imformats;
[d{1:length(f)}] = deal(f.description);
iTiff = find(contains(d, 'TIFF'));
if ~isequal(func2str(f(iTiff).info), strInfo);
    h = getfhandle(strInfo);
    f(iTiff).info = h;
    imformats(f);
end
for i=1:length(fnames)
    sInfo(i) = imfinfo(fnames{i});
end
if isfield(sInfo, 'ExposureTime')
    [st{1:length(sInfo)}] = deal(sInfo.ExposureTime);
    T = str2num(char(st));
else
    T = [];
end

if isfield(sInfo, 'Cycle')
    [sc{1:length(sInfo)}] = deal(sInfo.Cycle);
    C = str2num(char(sc));
else
    C = [];
end

