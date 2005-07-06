function [Igrid, Isegment] = gridImage(I, oPP, ppMode, rSize)

switch ppMode
    case 'none'
        Igrid = imresize(I, rSize);
        Isegment = I;
    case 'fast'
        oPP = rescale(oPP, rSize(1)/size(I,1));
        Igrid = getPrepImage(oPP, imresize(I, rSize));
        Isegment = I;
    case 'slow'
        Igrid = getPrepImage(oPP, I);
        Isegment = Igrid;
        Igrid = imresize(Igrid, rSize);
end
Igrid = histeq(Igrid);

        
   
        
