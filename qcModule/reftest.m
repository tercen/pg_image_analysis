% RefTest
clear all
v = vLoad('D:\temp\data\040818-M040630A-MW-C6 Q-results\F1\T20\Median\rTest_Fast.v');
disp('Select Normalizers ...');
clRefID = vPick(v, 'ID');
maps = vArrange96(v, 'ID', clRefID, 'EndLevel');
[s1,s2,s3] = size(maps);
refcols = reshape(maps,s1*s2, s3)
for i=1:s3
    mMaps(:,:,i) = maps(:,:,i)/mean(refcols(:,i));
end
refcols = reshape(mMaps, s1*s2*s3, 1);

%refcols = mean(refcols')';
figure(1)

fOpts.strMethod = 'Robust';
fOpts.MaxFunEvals = 100;
fOpts.FitDisplay = 'none';
fOpts.TolX = 0.001;

for i = 1:1
    %refcols(:,i) = refcols(:,i)/mean(refcols(:,i));
    m(i) = mean(refcols(:,i));
    s(i) = std(refcols(:,i));
    
    [cnt, xc] = hist(refcols(:,i), 15);
    count(:,i) = cnt';

    x(:,i) = xc';
    subplot(ceil(s3/2),2,i)
    hold off
    bar(x(:,i), count(:,i), 'y');
    hold on

    N(:,i) = max(count(:,i)) * NormalCurve(x(:,i), m(i), s(i));
    plot(x(:,i), N(:,i), 'r', 'LineWidth', 2)
    title(char(clRefID{i}), 'Interpreter', 'none');
    pOut = cfFit(x(:,i), count(:,i), [], @cfGaussm1, fOpts)
    plot(x(:,i), cfGaussm1(x(:,i), [], pOut) , 'k--', 'LineWidth', 2)
end
mMax = 1 + 3 * pOut(2)
mMin = 1 - 2.5 * pOut(2)
oMap = zeros(size(mMaps))+20;
iOutHigh = find(mMaps > mMax);
iOutLow  = find(mMaps < mMin);
oMap(iOutHigh) = 40;
oMap(iOutLow) = 0;







