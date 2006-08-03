function oq = quantify(oq, I)

% convert I to signed integer if necessary:
% (to allow negative values after background subtraction, later on)
switch class(I)
    case 'uint16'
        I = int16(I);
    case 'uint8'
        I = int8(I);
end        

[nRows, nCols] = size(oq);
for i=1:nRows
    for j = 1:nCols
        if isempty(oq(i,j).iBackground)
            oq(i,j) = setBackgroundMask(oq(i,j));
        end
        if isempty(oq(i,j).oOutlier)
            bOut = false;
        else
            bOut = true;
        end

        bwSignal= getBinSpot(oq(i,j).oSegmentation);    

        if any(bwSignal(:))
            sLocal = size(bwSignal);
            cLu = get(oq(i,j).oSegmentation, 'cLu');
            cLu = round(cLu);
            try
                imLocal = I(cLu(1):cLu(1)+ sLocal(1) -1, cLu(2): cLu(2) + sLocal(2) -1);
            catch
                i
                j
                cLu
                sLocal
                keyboard
            end
                % quantify signal
            sigPix = imLocal(bwSignal);
            if bOut
                [iOutSignal, sigLimits] = detect(oq(i,j).oOutlier, double(sigPix));
            else
                iOutSignal = false(size(sigPix));
            end
            oq(i,j).medianSignal = median(sigPix(~iOutSignal));
            oq(i,j).meanSignal = mean(sigPix(~iOutSignal));
            oq(i,j).stdSignal = std(sigPix(~iOutSignal));
            oq(i,j).minSignal = min(sigPix(~iOutSignal));
            oq(i,j).maxSignal = max(sigPix(~iOutSignal));
            % quantify background
            bgPix = imLocal(oq(i,j).iBackground);
            if bOut
                [iOutBackground, bgLimits] = detect(oq(i,j).oOutlier, double(bgPix));
            else
                iOutBackground = false(size(bgPix));
            end
            oq(i,j).medianBackground    = median(bgPix(~iOutBackground));
            oq(i,j).meanBackground      = mean(bgPix(~iOutBackground));
            oq(i,j).stdBackground       = std(bgPix(~iOutBackground));
            oq(i,j).minBackground       = min(bgPix(~iOutBackground));
            oq(i,j).maxBackground       = max(bgPix(~iOutBackground));
            % set ignored pixels
            oq(i,j).iIgnored = [];
            if bOut
                sigIgnored = bwSignal & (imLocal < sigLimits(1) | imLocal > sigLimits(2));
                bgMask = getBackgroundMask(oq(i,j)); 
                bgIgnored =  bgMask &  (imLocal < bgLimits(1) | imLocal > bgLimits(2));
                oq(i,j).iIgnored = find( sigIgnored(:)|bgIgnored(:) );
            end
            % for the rank test:
            % since pixel intensities are integere, we can handle the ties
            % in MW test below by adding 0.5 to one of the
            % distributions (here: sigPix)
            oq(i,j).pSignal = test2r(double(sigPix(~iOutSignal))+0.5, double(bgPix(~iOutBackground)), 'n');
            nPix = length(sigPix(~iOutSignal));
            oq(i,j).signalSaturation = length(find(sigPix(~iOutSignal) >= oq(i,j).saturationLimit))/nPix;    
        end
        %%%%%%%%%%%%%%
    end
end






