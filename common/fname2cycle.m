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
  iSlash = findstr(fname, '\');
  iSlash = iSlash(length(iSlash));
  bName = fname(iSlash+1:length(fname));
  [aID, fID, iID, pID] = imgReadWFTP(bName, [],szInstrument);
  pID = char(pID);
  pID = pID(2:length(pID));
  c = str2num(pID);
end

if isequal(szInstrument, 'PS4') 
  iSlash = findstr(fname, '\');
  iSlash = iSlash(length(iSlash));
  bName = fname(iSlash+1:length(fname));
  [aID, fID, iID, pID] = imgReadWFTP(bName, [],szInstrument);
  pID = char(pID);
  pID = pID(2:length(pID));
  c = str2num(pID);
end


if isequal(szInstrument, 'FD10')
    ii = findstr(fname,'_');
    ii = ii(length(ii));
    fi = findstr(fname,'.');
    fi = fi(length(fi));
    c = str2num(fname(ii+1:fi-1));
end