function hImage = showOutline(oQ, I, fr);
hold off
if nargin < 3
    fr = double(max(I(:)));
end
cLu = get(oQ.oSegmentation, 'cLu');
bsSize = get(oQ.oSegmentation, 'bsSize');
x = cLu(1):cLu(1) + bsSize(1) - 1;
y = cLu(2):cLu(2) + bsSize(2) - 1;
Ispot = double(I(round(x),round(y)))/fr;
hImage = imshow(Ispot, [0,1]);
colormap(gca, 'jet');
hold on

[x,y] = getOutline(oQ.oSegmentation);

if oQ.isEmpty
    plot(y , x, 'k');
elseif oQ.isBad
    plot(y,  x, 'r');
else
    plot(y,x,'w')
end

bg = get(oQ, 'backgroundMask');
L = bwlabel(double(bg));
B = bwboundaries(L);
nb = length(B);
for i=1:nb
    bounds = B{i};
    plot(bounds(:,2), bounds(:,1), 'k')
end