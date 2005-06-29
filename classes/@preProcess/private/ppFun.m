function Ipp = ppFun(p, I)
% Ipp = ppFun1(I, par)
% Image preprocessing filter
% par(1) = nSmallDisk, if > 0 size of small disk element (pix) for morph.
% open (small artifact removal)
% par(2) = nLargeDisk, if > 0 size of large disk element (pix) for tophat
% filter (reduction of bg/halo etc.)
% par(3) = nLpf, if > 0 size of lpf filter (pix)
% par(4) = nRoiDiam, if > 0, size of circular mask imposed on image

nSmallDisk   = p.nSmallDisk;
nLargeDisk   = p.nLargeDisk;
nFilter      = p.nBlurr;
nRoiDiam     = p.nCircle;

Ipp = I;
if (nSmallDisk > 0)
    se = strel('Disk', nSmallDisk);
    Ipp = imerode(Ipp, se);
    Ipp = imdilate(Ipp, se);
end
if (nLargeDisk > 0) & (nRoiDiam <= 0)
    se = strel('Disk', nLargeDisk);
    Io = imerode(Ipp, se);
    Io = imdilate(Io, se);
    Ipp = imsubtract(Ipp, Io);
end
if (nLargeDisk > 0) & (nRoiDiam > 0)
    se = strel('Disk', nLargeDisk);
    t = [0:pi/20:2*pi];
    x = round((nRoiDiam/2)) * sin(t);
    y = round((nRoiDiam/2)) * cos(t);
    x2 = round(1.2*nRoiDiam/2)*sin(t);
    y2 = round(1.2*nRoiDiam/2)*cos(t);
    sI = size(Ipp);
    
    iRoi2 = roipoly(sI(1), sI(2),  x2 +sI(2)/2 , y2 + sI(1)/2);
    Io = imerode(Ipp, se);
    Io = immultiply(Io, iRoi2);
    Io = imdilate(Io, se);
    Io = imsubtract(Ipp, Io);
    Ipp = imlincomb(0.5,Ipp, 3, Io);
    iRoi1 = roipoly(sI(1), sI(2), x +sI(2)/2 , y + sI(1)/2);
    mF = (1./(nFilter*nFilter))*ones(nFilter);
    iRoi1 = double(iRoi1);
    iRoi1 = imfilter(iRoi1, mF);
    Ipp = double(Ipp).* double(iRoi1);
%     Ipp = uint16(Ipp);
%     Inoise = uint16(100*randn(size(Ipp)));
%     Ipp = imadd(Ipp, Inoise);
end

if (nLargeDisk <= 0) & (nRoiDiam > 0)
    t = [0:pi/20:2*pi];
    x = round((nRoiDiam/2)) * sin(t);
    y = round((nRoiDiam/2)) * cos(t);
    sI = size(Ipp);
    iRoi1 = roipoly(sI(1), sI(2), x +sI(2)/2 , y + sI(1)/2);
    mF = (1./(nFilter*nFilter))*ones(nFilter);
    iRoi1 = double(iRoi1);
    iRoi1 = imfilter(iRoi1, mF);
    Ipp = double(Ipp) .* double(iRoi1);
%   Ipp = uint16(Ipp);
end

switch class(I)
    case 'uint8'
        Ipp = uint8(Ipp);
    case 'double'
        Ipp = double(Ipp);
    case 'uint16'
        Ipp = uint16(Ipp);
end



%EOF