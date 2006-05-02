function pathLocation = fullpath(d,nList)

if isnumeric(nList) 
    sEntry = d.list(nList);
elseif isstruct(nList)
    sEntry = nList;
end
pathLocation = fullfile(sEntry.path, sEntry.name);