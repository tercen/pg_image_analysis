%svdpat
close all;
clear all;

dDir = 'D:\temp\data\SO-0285C27-on StandardKinase-run 10-03-31 08-Mar-2005\SO-0285C27-on StandardKinase-run 10-03-31 08-Mar-2005-ImageResults\_Quantified Results\F1\T32\Median';
anFile = 'D:\temp\data\SO-0285C27-on StandardKinase-run 10-03-31 08-Mar-2005\SO-0285C27-on StandardKinase-run 10-03-31 08-Mar-2005-ImageResults\_CurveFit Results\annot.txt';
sType = '*mBg.dat';
nComponents = 2;

%***************************** House Keeping ********************************************
dStruct = dir([dDir,'\',sType]);
% map names to Index1, Index2 of PS96
for i=1:length(dStruct);
    [r,c] = fname2rc(dStruct(i).name, 'PS96');
    dStruct(i).Index1 = r;
    dStruct(i).Index2 = c;
end

% annotate the entries
[dStruct, annFields] = vAnnotate96(dStruct, anFile);
iMatch = strmatch('sysOK', annFields);
annFields = annFields([1:iMatch-1, iMatch+1:end]);

for i=1:length(dStruct)
    strAnn = [];
    for j= 1:length(annFields)
        strAnn = [strAnn,'_',dStruct(i).(annFields{j})];
    end
    dStruct(i).annotation = strAnn;
end

% load selected data
clInclude = vPick(dStruct, 'annotation');
drawnow
[aList{1:length(dStruct)}] = deal(dStruct.annotation);
Y = [];
nFiles = length(clInclude);
nLoaded = 0;
for i=1:nFiles
    iMatch = strmatch(clInclude{i}, aList);
    for j = 1:length(iMatch)
        if ~isequal(dStruct(iMatch(j)).sysOK, 'n');
            try
                [hdr, data] = hdrload([dDir, '\', dStruct(iMatch(j)).name]);
            catch
                error(['error loading match ',num2str(iMatch(j)),': ',dStruct(iMatch(j)).name]);
            end

            clHdr = strread(hdr, '%s', 'delimiter', '\t');
            clHdr = clHdr(2:end);
            dStruct(iMatch(j)).x = data(:,1);
            y = pp(data(:,2:end));
            dStruct(iMatch(j)).y = data(:,2:end);
            dStruct(iMatch(j)).clHdr = clHdr(2:end);
            dStruct(iMatch(j)).strLabel = [clInclude{i},'_#',num2str(j)];
            % stack data
            Y = [Y, y];
            nLoaded = nLoaded + 1;
            Loaded(nLoaded) = dStruct(iMatch(j));
            
        end
        
    end
end

nSpots = length(clHdr);

% *************************** Computations **************************************
[U, S, V] = svd(Y');
s = diag(S);
s = s/sum(s);
figure(1)
bar(s);
C = U*S;
% unstack components
for i=1:nLoaded
    ini     = 1 + (i-1)*nSpots;
    fin     = (ini-1) + nSpots; 
    Cu(:, 1:nComponents, i) =  C(ini:fin,1:nComponents);
end

% calculate distance map
for i=1:nLoaded
    for j=1:nLoaded
        delta = Cu(:,:,i) - Cu(:,:,j);
        chi = delta.^2;
        X(i,j) = sum(sum(chi'));
    end
end

[clLabel{1:nLoaded}] = deal(Loaded.strLabel);
mX = zeros(length(clInclude), length(clInclude));



col = 1;
for i=1:length(clInclude)
    for j=1:length(clInclude)
        clInclude{j}
        
        iMatch = strmatch(clInclude{j}, clLabel);
        if j==1
            sBlock = length(iMatch)
        end
        block = X(iMatch,col);
        mX(j,i) = mean(block(block ~= 0)); 
        eX(j,i) = std(block(block~=0));
       
    end
    col =col + sBlock;
end

    





for i=1:nLoaded
    h(i) = text(-v(2)/4, i, Loaded(i).strLabel);
    f(i) = text(i, v(4), Loaded(i).strLabel);
end
set(gcf', 'color', 'k')
set(h, 'interpreter', 'none', 'fontsize', 6, 'color', 'w')
set(f, 'interpreter', 'none', 'fontsize', 6, 'rotation', 90, 'color', 'w')

nMeas = 0;
for i=1:length(clInclude)
     iMatch = strmatch(clInclude{i}, clLabel);
     if isequal(Loaded(iMatch(1)).sysCM, 'M')
         nMeas = nMeas + 1;
         [mXm(:,nMeas), iSort] = sort(mX(:,i), 'ascend');
         sLabel(:,nMeas) = clInclude(iSort)
         eXm(:, nMeas) = eX(iSort , i);   
     end
end

for i=1:nMeas
    figure
    set(gcf, 'position', [40,421,949,259])
    sx = sum(mXm(:,i));
    e(i) = errorbar([1:length(clInclude)]', mXm(:,i)/sx, eXm(:,i)/sx, eXm(:,i)/sx, 'o-');
    ylabel('distance')
    xlabel('condition')
    set(gca, 'xTick', [])
    for j=1:length(clInclude)
        t(j) = text(j, mXm(j,i)/sx, sLabel{j,i});
    end
    set(t, 'fontsize', 8, 'rotation', 45,'interpreter', 'none')
    title(sLabel{1,i}, 'interpreter', 'none');
    
end
   

 
            

    
    
