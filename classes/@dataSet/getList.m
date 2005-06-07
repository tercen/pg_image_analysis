function list = getList(d)

switch d.instrument
    case 'PS96'
        list = searchPS96(d.path, d.filter);
    otherwise
        error(['Unknown instrument: ', d.instrument]);
end
