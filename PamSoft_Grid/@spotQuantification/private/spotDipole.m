function D = spotDipole(I, bIn, oS)

[i,j] = find(true(size(I)));% coordinates into the image;
mp  = get(oS, 'finalMidpoint');
r   = get(oS, 'diameter')/2;
bIn = bIn(:);

ii = ([i,j] - mp(ones(size(I)),:))/r; %normalized image coordinates
II = double([I(:), I(:)]);

dc = sum(ii(bIn,:).*II(bIn,:));
D = sqrt(sum(dc.^2))/sum(bIn);




