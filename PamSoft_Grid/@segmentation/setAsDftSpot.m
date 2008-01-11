function oS = setAsDftSpot(oS,dftSpotSize)

if nargin < 2
       dftSpotSize = [];
end


for i=1:length(oS)
    if isempty(oS(i).bsSize)
        error('bsSize (binSpot) property has not been set');
    end
    if isempty(dftSpotSize)
        dftSpotSize = 0.6 * oS(i).spotPitch;
    end
   
    oS(i).finalMidpoint = oS(i).initialMidpoint;
    oS(i).diameter = dftSpotSize;
    oS(i).bsLuIndex = oS(i).finalMidpoint - round(oS(i).bsSize)/2; 
    [x,y] = getOutline(oS(i), 'coordinates', 'local');   
    [xc,yc] = find(true(oS(i).bsSize));
    in = inpolygon(xc,yc, x, y);
    oS(i).bsTrue = find(in);
       
end