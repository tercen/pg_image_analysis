function hImage = showOutline(oQ, I, fr)
hold off
if nargin < 3
    fr = double(max(I(:)));
end
Ispot = localImage(oQ.oSegmentation, I);
Ispot = double(Ispot)/fr;
hImage = imshow(Ispot, [0,1]);
colormap(gca, 'jet');
hold on

[x,y] = getOutline(oQ.oSegmentation, 'coordinates', 'local');
hOutline = plot(y, x, 'w');

if oQ.isEmpty
    set(hOutline, 'color', 'k');
elseif oQ.isBad
    set(hOutline, 'color', 'r');
end

bg = get(oQ, 'backgroundMask');
L = bwlabel(double(bg));
B = bwboundaries(L);
nb = length(B);
for i=1:nb
    bounds = B{i};
    plot(bounds(:,2), bounds(:,1), 'k')
end