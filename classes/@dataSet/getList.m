function d = getList(d)

switch d.instrument
    case 'detect';
        [list, instrument] = searchDetect(d.path, d.filter);
        d.instrument = instrument;
    case 'PS96'
        list = searchPS96(d.path, d.filter);
    otherwise
        error(['Unknown instrument: ', d.instrument]);
end
d.list = list;