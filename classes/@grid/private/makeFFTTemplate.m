function fTemplate = makeFFTTemplate(g, iSize);
template = makeTemplate(g, iSize);
for i=1:size(template,3)
    fTemplate(:,:,i) = fft2(template(:,:,i));
end

    