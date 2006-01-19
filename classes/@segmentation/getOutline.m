function [x,y] = getOutline(oS)

x = [];
y = [];
switch oS.method
    case 'Edge'
        mo = oS.methodOutput;
        if ~isempty(mo)
            r = mo.spotRadius;
            [x,y]  = circle(mo.spotMidpoint(1), mo.spotMidpoint(2), r, 2*pi*r);
            
        end
        case 'Threshold'
            bs = getBinSpot(oS);
            if any(bs(:))
                B = bwboundaries(double(bs));
                bound = B{1};
                x = bound(:,1);
                y = bound(:,2);
            end
end

        

