function s = setAsDftSpot(s,dftSpotSize)
if numel(s) > 1
    error('setAsDftSpot only works for scalar objects')
end
if isempty(s.bsSize)
   error('bsSize (binSpot) property has not been set');
end

if isempty(dftSpotSize) || nargin < 2
    % take size of binSpot as 2*spotPitch
    spotPitch = 0.5 * s.bsSize(1);
    dftSpotSize = 0.6 * spotPitch;
end

mp = 0.5 * s.bsSize;
r = dftSpotSize/2;
[x,y] = circle(mp(1), mp(2), r, round(pi*r)/2);
[xc,yc] = find(true(s.bsSize));
in = inpolygon(xc,yc, x, y);;
s.bsTrue = find(in);
cLu = round(s.mp0 - spotPitch);
cLu(cLu<1) = 1;
s.cLu = cLu;
s.methodOutput.spotMidpoint = mp;
s.methodOutput.spotRadius = r;
