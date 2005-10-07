function strID = fromtemplate(strFileName, strRefMarker)
global mask
global xOffset
global yOffset
global spotPitch
global spotSize
global rotation

temp = array();
[temp, strID] = fromFile(temp, strFileName, strRefMarker);
mask        = get(temp, 'mask');
xOffset     = get(temp, 'xOffset');
yOffset     = get(temp, 'yOffset');

% EOF