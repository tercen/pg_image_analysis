function oq = quantify(oq, I)
% function oq = quantify(oq, I)
% IN: 
% oq: array of spotQuantification objects (one for each spot) with relevant
% properties set 
% I: image to quantify
% OUT:
% oq: array of spotQuantification objects (corresponding to IN) contatining
% the quantification


[nRows, nCols] = size(oq); % this is obsolete, the double loop over nRow and nCols can (will) be replaced by a single loop over length(oq(:))

for i=1:nRows
    for j = 1:nCols
        % this sets the mask for the background pixels
        % (spotQuantification.setBackgroundMask method)
        if isempty(oq(i,j).iBackground)
            oq(i,j) = setBackgroundMask(oq(i,j));
        end
        
        if isempty(oq(i,j).oOutlier)
            bOut = false;
        else
            bOut = true;
        end

        % get the foreground pixel mask from the segmentation    
        bwSignal= getBinSpot(oq(i,j).oSegmentation);

        if any(bwSignal(:))
            sLocal = size(bwSignal);
            cLu = get(oq(i,j).oSegmentation, 'cLu');
            cLu = round(cLu);
            
            % imLocal is the image "zoomed" around the spot
            imLocal = I(cLu(1):cLu(1)+ sLocal(1) -1, cLu(2): cLu(2) + sLocal(2) -1);         
           % quantify signal
            sigPix = imLocal(bwSignal); % array of pixles making up the spot
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
            % since pixel intensities are integer, we can handle the ties
            % in MW test below by adding 0.5 to one of the
            % distributions (here: sigPix)
            %oq(i,j).pSignal = test2r(double(sigPix(~iOutSignal))+0.5, double(bgPix(~iOutBackground)), 'n');
            oq(i,j).pSignal = ranksum(double(sigPix(~iOutSignal))+0.5, double(bgPix(~iOutBackground)), 'method', 'approximate');
            nPix = length(sigPix(~iOutSignal));
            oq(i,j).signalSaturation = length(find(sigPix(~iOutSignal) >= oq(i,j).saturationLimit))/nPix;    
        end
        %%%%%%%%%%%%%%
    end
end






