function bg = backgroundInterleaved(oq, I, cx, cy);

bg = [];

% background positions
dx = cx(2,1) - cx(1,1);
dy = cy(1,2) - cy(1,1); 
xi = zeros(size(cx) + 1);
yi = zeros(size(cy) + 1);
xi(2:end, 2:end) = cx;
yi(2:end, 2:end) = cy;
xi(:,1) = xi(:,2);
xi(:,end) = xi(:,end-1);
yi(:,1) = yi(:,2) - dy;
yi(:,end) = yi(:,end-1) + dy;
xi(1,:) = xi(2,:) -dx;
xi(end,:) = xi(end-1,:) + dx;
yi(1,:) = yi(2,:);
yi(end,:) = yi(end-1,:);

xi  = xi + 0.5*dx;
yi =  yi + 0.5*dy;

% relative background coordinates
se = strel('disk', round(oq.backgroundDiameter/2));
disk = getnhood(se);
sDisk = size(disk);
[xDisk, yDisk] = find(disk);
mp = 1 + sDisk/2;
xDisk = xDisk - mp(1);
yDisk = yDisk - mp(2);

[nRows,nCols] = size(xi);
for i=1:nRows
    for j=1:nCols
        x = round(xi(i,j) + xDisk);
        y = round(yi(i,j) + yDisk);
        iLin = sub2ind(size(I), x,y);
        data = double(I(iLin));
        q = quantile(data, oq.backgroundPercentiles);
        data = data(data > q(1) & data < q(2)); 
        
        if isequal(oq.quantitationMetric, 'median')
            bgInterleaved(i,j) = median(data);
        elseif isequal(oq.quantitationMetric, 'mean')
            bgInterleaved(i,j) = mean(data);
        end
        I(iLin) = 2^16;
    end
end

bg = interp2(1:nCols, 1:nRows, double(bgInterleaved), 0.5 + [1:nCols-1], 0.5 + [1:nRows-1]');
end
        
        








