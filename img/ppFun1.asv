function Ipp = ppFun1(I, par)
% Ipp = ppFun1(I, par)
% Image preprocessing filter
% par(1) = nSmallDisk, if > 0 size of small disk element (pix) for morph.
% open (small artifact removal)
% par(2) = nLargeDisk, if > 0 size of large disk element (pix) for tophat
% filter (reduction of bg/halo etc.)
% par(3) = nLpf, if > 0 size of lpf filter (pix)
% par(4) = nRoiDiam, if > 0, size of circular mask imposed on image

nSmallDisk   = par(1);
nLargeDisk   = par(2);
nLpf         = par(3);
nRoiDiam     = par(4);

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
    iRoi    = roipoly(sI(1), sI(2), x +sI(2)/2 , y + sI(1)/2);
    iRoi2   = roipoly(sI(1), sI(2), x2+sI(2)/2, y2 + sI(1)/2);
    Io = imerode(Ipp, se);
    Io = immultiply(Io, iRoi2);
    Io = imdilate(Io, se);
    Ipp = imsubtract(immultiply(Ipp, iRoi), immultiply(Io, iRoi));
end

if (nLargeDisk <= 0) & (nRoiDiam > 0)
    t = [0:pi/20:2*pi];
    x = round((nRoiDiam/2)) * sin(t);
    y = round((nRoiDiam/2)) * cos(t);
    sI = size(Ipp);
    iRoi    = roipoly(sI(1), sI(2), x +sI(2)/2 , y + sI(1)/2);
    Ipp = immultiply(Ipp, iRoi);
end

if (nLpf > 0)
    fLpf = nLpf.^(-2) * ones(nLpf);
    Ipp = imfilter(Ipp, fLpf);
end
%EOF