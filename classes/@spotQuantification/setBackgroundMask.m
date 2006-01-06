function oq = setBackgroundMask(oq)
if isempty(oq.oSegmentation)
    error('Segmentation object has not been set');
end
s = get(oq.oSegmentation, 'binSpot');

switch oq.backgroundMethod
    case 'localCorner'
        oq.iBackground = localCornerMask(size(s));
end
