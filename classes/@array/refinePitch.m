function oArray = refinePitch(oArray,xPos, yPos)

    

isRef = oArray.isreference;

r =     abs(oArray.row(isRef))';
c =     abs(oArray.col(isRef))';
xPos = xPos(isRef)';
yPos = yPos(isRef)';
% correct for the inferred rotation
teta = -(2*pi/360) * oArray.rotation;
R = [cos(teta), -sin(teta);
    sin(teta), cos(teta)];
v = (R * [xPos;yPos]);

% get the number of row pitch and column pitch  measures in the set
nr = length(unique(r)) -1;
nc = length(unique(c)) -1;
if nr > 0 && nc  < 1
    pitch= (v(1,:)-min(v(1,:)))/(r-min(r)); 
elseif nr < 1 && nc > 0    
    pitch = (v(2,:)-min(v(2,:)))/(c-min(c));
elseif nr > 0 && nc > 0
    pitch(1)= (v(1,:)-min(v(1,:)))/(r-min(r)); 
    pitch(2) = (v(2,:)-min(v(2,:)))/(c-min(c));
    pitch = (nr* pitch(1) + nc* pitch(2))/(nr + nc);
else
    pitch = [];
end
oArray.spotPitch = pitch;