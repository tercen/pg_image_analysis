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
for i=1:length(dStruct)
    strAnn = [];
    for j= 1:length(annFields)
        strAnn = [strAnn,'_',dStruct(i).(annFields{j})];
    end
    dStruct(i).annotation = strAnn;
end

% load selected data
clInclude = vPick(dStruct, 'annotation');
[aList{1:length(dStruct)}] = deal(dStruct.annotation);
Y = [];
nFiles = length(clInclude);
for i=1:nFiles
    iMatch = strmatch(clInclude{i}, aList);
    [hdr, data] = hdrload([dDir, '\', dStruct(iMatch).name]);
    clHdr = strread(hdr, '%s', 'delimiter', '\t');
    clHdr = clHdr(2:end);
    dStruct(iMatch).x = data(:,1);
    y = pp(data(:,2:end));
    dStruct(iMatch).y = data(:,2:end);
    dStruct(iMatch).clHdr = clHdr(2:end);
    % stack data
    Y = [Y, y];
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
for i=1:nFiles
    ini     = 1 + (i-1)*nSpots;
    fin     = (ini-1) + nSpots; 
    Cu(:, 1:nComponents, i) =  C(ini:fin,1:nComponents);
end

% calculate distance map
for i=1:nFiles
    for j=1:nFiles
        delta = Cu(:,:,i) - Cu(:,:,j);
        chi = delta.^2;
        X(i,j) = sum(sum(chi'));
    end
end
% show map
sX = sum(sum(X));
imshow(X/sX, [], 'initialmagnification', 'fit');
colormap('jet');
set(gca, 'xtick', 1:nFiles, 'ytick', 1:nFiles, 'yticklabel', [], 'xticklabel', [], 'visible', 'on');
% add labels
v = axis;
for i=1:nFiles
    h(i) = text(-v(2)/4, i, clInclude{i});
    f(i) = text(i, v(4), clInclude{i});
end
set(gcf', 'color', 'k')
set(h, 'interpreter', 'none', 'fontsize', 6, 'color', 'w')
set(f, 'interpreter', 'none', 'fontsize', 6, 'rotation', 90, 'color', 'w')




    
   