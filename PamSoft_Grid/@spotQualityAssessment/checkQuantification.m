function flag = checkQuantification(sa, q)
qs = get(q(:));
flag = zeros(length(qs),1);
% 1. find those spots that are considered empty:
bEmpty = [qs.pSignal] > sa.maxPValue;
flag(bEmpty) = 2;

% 2. spots that were previously replaced and are not empty are considered
% bad spots
% flag(~bEmpty & [qs.isReplaced]) = 1;

% 3. spots with an apparent miss-allignment are considered bad spots
bMiss = [qs.dipole] < sa.maxDipole;

flag(bMiss) = 1;





        
