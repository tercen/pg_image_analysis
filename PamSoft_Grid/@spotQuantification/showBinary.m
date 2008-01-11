function showBinary(oQ)
spot = getBinSpot(oQ.oSegmentation);
ignored = get(oQ, 'ignoredMask');
bg      = get(oQ, 'backgroundMask');

binview = double(spot);
binview(bg) = 0.5;
binview(ignored) = 0.25;

imshow(binview);
colormap(gca, 'jet');