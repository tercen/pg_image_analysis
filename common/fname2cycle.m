function c = fname2cycle(fname, szInstrument)

c = -1;

if isequal(szInstrument, 'nEvolve')
       ii = findstr(fname,'_');
    ii = ii(length(ii));
    fi = findstr(fname,'.');
    fi = fi(length(fi));

    c = str2num(fname(ii+2:fi-1));
end


if isequal(szInstrument, 'PS96')
    ii = findstr(fname,'_');
    ii = ii(length(ii));
    fi = findstr(fname,'.');
    fi = fi(length(fi));

    c = str2num(fname(ii+1:fi-1));
end
if isequal(szInstrument, 'FD10')
    ii = findstr(fname,'_');
    ii = ii(length(ii));
    fi = findstr(fname,'.');
    fi = fi(length(fi));
    c = str2num(fname(ii+1:fi-1));
end