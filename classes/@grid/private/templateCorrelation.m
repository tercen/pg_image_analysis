function [mxcor, iRot]  = templateCorrelation(Image, fftRotTemplate)
% function [mxcor, rotation] = templateCorrelation(Image, Templatet);
fftImage        = fft2(single(Image));


for i=1:size(fftRotTemplate,3)
    fftTemplate = fftRotTemplate(:,:,i);
    C = real(ifft2(fftImage.*conj(fftTemplate)));    
    C = fftshift(C);
    [mx, idx] = maxn(C);
    c(i) = mx(1);
    [x,y] = ind2sub(size(C), idx(1));
    mxcor(i,:) = [x,y]; 
end
[mx, iRot] = max(c);
mxcor = mxcor(iRot,:);
