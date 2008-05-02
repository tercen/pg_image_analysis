function [q, spotPitch, mp] = segmentAndRefine(pgr, I, x, y, rot)
% Segments and attempts to refine the spotpitch
if isequal(pgr.optimizeSpotPitch', 'yes')
    % this determines if (a) spotPitch refinement iteration(s) will be
    % performed
    maxIter = 2;
else
    maxIter = 1;
end

if isequal(pgr.verbose, 'on')
    bVerb = true;
else
    bVerb = false;
end


maxDelta = 0.3;
spotPitch = get(pgr.oArray, 'spotPitch');

mp = midPoint(pgr.oArray, x,y);
fxdx = get(pgr.oArray, 'xFixedPosition');
bFixedSpot = fxdx ~= 0;

% start the refinement loop, terminate when the refinedSpotPitch is close
% enough to the input spotPitch  (or when maxIter is reached);
iter = 0;
delta = maxDelta + 1;
while delta > maxDelta
    iter = iter + 1;
    if iter > maxIter
        break;
    end
    pgr.oSegmentation = set(pgr.oSegmentation, 'spotPitch', spotPitch);
    oS = segment(pgr.oSegmentation, I, x, y,rot);
    
    flags = checkSegmentation(pgr.oSpotQualityAssessment, oS);
    % replace empty spots by the default spot
    oS(flags == 2) = setAsDftSpot(oS(flags == 2));
    if all(bFixedSpot)
        break;
    end
    % if too little spots are correctly found, skip spot pitch refinement
    % here:
    bUse = flags == 0 & ~bFixedSpot;
    if length(find(bUse)) < 5
        break;
    end
    % Use the spots found to refine the pitch and array midpoint
    % exclude fixed points from the refinement
    
 
    [xPos, yPos] = getPosition(oS);
    array2fit = set(pgr.oArray, 'isreference',bUse);
    arrayRefined = refinePitch(array2fit, xPos, yPos);
    arrayRefined = set(arrayRefined, 'isreference', true(size(x)));
    refSpotPitch = get(arrayRefined, 'spotPitch');
    delta = abs(refSpotPitch - spotPitch);
    mp = midPoint(arrayRefined, xPos, yPos);

    % calculate array coordinates based on refined pitch
    [xr,yr] = coordinates(arrayRefined, mp, rot);

    if bVerb
        disp('Spot pitch optimization')
        disp(['iter ',num2str(iter)]);
        disp(['delta: ', num2str(delta)]);
        disp(['sp in: ', num2str(spotPitch)]);
        disp(['sp out: ', num2str(refSpotPitch)]);
        if delta <= maxDelta
            disp('Spot pitch optimization finished')
        end
    end
    spotPitch = refSpotPitch;
    x(~bFixedSpot) = xr(~bFixedSpot);
    y(~bFixedSpot) = yr(~bFixedSpot);
end
% replace bad spots by the default spot

oS(flags == 1) = setAsDftSpot(oS(flags == 1));

% create the array of spotQuantification objects for output.

q = setSet(pgr.oSpotQuantification, ...
                'oSegmentation', oS, ...
                'isEmpty', flags == 2, ...
                'isBad', flags == 1, ...
                'isReplaced', flags > 0);
            


            