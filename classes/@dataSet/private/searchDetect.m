function [list, instrument] = searchDetect(path, filter, forceStructure)
% check for image results
dirList = dir(path);
if forceStructure
    bFound = 0;
    for i=1:length(dirList)
        if dirList(i).isdir && ~isempty(findstr(dirList(i).name, 'ImageResults'));
            bFound = 1;
            srchDir = [path, '\', dirList(i).name];
            break;
        end
    end
else
    bFound = 1;
    srchDir = path;
end

if ~bFound
    error('dataSet:NoImageResults', '%s', ['No ImageResults found in: ',path]);
end

fList = filehound(srchDir, filter);
n = 0;
list = struct([]);
bFD10 = 0;
bQC = 0;
for i=1:length(fList)
    bName = fList(i).fName;

    % Detect non WFTP data naming sets like FD10 and QC system
    if ~isempty(findstr(bName, 'TestSite'));
        % detect FD10 named data
        bFD10 = 1
        break;
    end

    iPoint = findstr('.', bName);
    bName = bName(1:iPoint-1);
    a = strread(bName, '%s', 'delimiter', '_');

    if length(a) > 2
        if ~isempty(str2num(a{end-1})) && ~isempty(str2num(a{end}))
            bQC = 1;
            break;
        end

    end
    
    % read in WFTP set
    
    bWFTP = 1;
    iW = strmatch('W', a);
    iF = strmatch('F', a);
    iT = strmatch('T', a);
    iP = strmatch('P', a);
    iC = strmatch('C', a);
    iS = strmatch('S', a);


    if ~isempty(iW) && ~isempty(iT) && ~isempty(iF) && ~isempty(iP)
        n = n+1;
        list(n).name = fList(i).fName;
        list(n).path = fList(i).fPath;
        list(n).W = a{iW};
        list(n).F = a{iF};
        list(n).T = a{iT};
        list(n).P = a{iP};
        if ~isempty(iC)
            list(n).C = a{iC};
        else
            list(n).C = [];
        end
        if ~isempty(iS)
            list(n).S = a{iS};
        else
            list(n).S = [];
        end

    end
end

% detect WFTP instrument
if ~bFD10 & ~bQC
    if isempty(list)
        error(['No data found in: ', path])
    end
    
    if isempty(str2num(list(1).W(2)))
        % detect PS96 naming
        instrument = 'PS96';
    else
        str = [list(1).path, '\', list(1).name];
        info = imfinfo(str);
        is = [info.Height, info.Width];
        if is < 1000
            instrument = 'PS4_12';
        else
            instrument = 'PS4_23';
        end
    end
end

if bFD10
    % TO DO;
    instrument = 'FD10';
    error(['Sorry, FD10 named data is not supported']);
end

if bQC
  % map qc naming to PS96 naming
  instrument = 'QC96';
  n = 0;
  for i=1:length(fList)
      rowStr = ['ABCDEFGH'];
      colStr = ['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
      bName = fList(i).fName;
      iPoint = findstr(bName, '.');
      iPoint = iPoint(end);
      bName = bName(1:iPoint-1);
      a = strread(bName, '%s', 'delimiter', '_');
      nChip = str2num(a{end-1});
      nArray = str2num(a{end});
      W = [];
      if nChip <= 12 & nArray >= 1 & nArray <=4 
        W = ['W',rowStr(nArray),colStr(nChip,:)];
      elseif nChip > 12 & nArray >= 1 & nArray <=4 
        W = ['W',rowStr(nArray+4),colStr(nChip-12,:)];
      end
      if ~isempty(W)
        n = n+1;
        list(n).name = fList(i).fName;
        list(n).path = fList(i).fPath;
        list(n).W    = W;
        list(n).P    = 'P1';
        list(n).F    = 'FX';
        list(n).T    = 'TX';
        list(n).C    = [];
        list(n).S    = [];
        
      
      
      end
      
  end
end
   


    