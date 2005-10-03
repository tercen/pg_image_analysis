function [nWidth, nHeight, bitDepth] = readImageInfoFromFile(imagePath)
info = imfinfo(imagePath)
for i=1:length(info)
    nWidth(i)   = info(i).Width;
    nHeight(i)  = info(i).Height;
    bitDepth(i) = info(i).bitDepth;
end
% EOF