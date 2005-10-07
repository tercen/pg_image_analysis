function showgrid(image, xGrid, yGrid);
global mask
global xOffset
global yOffset
global spotPitch
global spotSize
global rotation

imshow(image, []);
hold on
colormap('jet');
plot(yGrid, xGrid, 'wx');

