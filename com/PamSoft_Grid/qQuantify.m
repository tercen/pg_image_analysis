function  [qTypes, array2Index] = qQuantify(imagePath)
global prpContrast
global prpLargeDisk
global prpSmallDisk
global prpCircleDiameter
global prpCircleBlurr
global prpResize
global grdMask
global grdRotation
global grdSpotPitch
global grdSpotSize
global grdXOffset
global grdYOffset
global grdUseImage
global segMethod
global segEdgeSensitivity
global segAreaSize
global sqcMaxDiameter
global sqcMinDiameter
global sqcMinFormFactor
global sqcMaxAspectRatio
global sqcMaxPositionOffset
global qntSpotID
global qntSeriesMode
global qntSaturationLimit
global qntBackgroundMethod
global qntOutlierMethod
global qntOutlierMeasure
global stateQuantification

if ~iscell(imagePath)
    imagePath = cellstr(imagePath);
end

nImages = length(imagePath);
if isempty(stateQuantification)
    error('Segmentation has not been set');
end

nq = size(stateQuantification,3);
if nq ~= 1 & nq ~= nImages
    error('With the current object state this method expects ',num2str(nq),' images');
end
nRead = 0;
for i=1:nImages
    if ~isempty(imagePath(i));
        nRead = nRead + 1;
        I(:,:,nRead) = imread(imagePath{i});
    end
end
% check if parameter set, otherwise refer to defaults
pdef = getProperties();
for i=1:length(pdef) 
    if eval(['isempty(',pdef(i).name,')'])
        for j=1:length(pdef(i).dft)
            sj = num2str(j);
            eStr = [pdef(i).name,'(',sj,') =', num2str(pdef(i).dft(j)),';'];
            eval(eStr);
    
        end
    end
end
% map enumerated props
[val, map]= getpropenumeration('prpContrast');
strPrpContrast = char(map(prpContrast == val));
[val, map]    = getpropenumeration('segMethod');
strSegMethod = char(map(segMethod == val));
[val, map] = getpropenumeration('qntBackgroundMethod');
strQntBackgroundMethod = char(map(qntBackgroundMethod == val));
[val, map] = getpropenumeration('qntOutlierMethod');
strQntOutlierMethod = char(map(qntOutlierMethod == val));


for i=1:nImages
    if nq == 1
        nQ0 = 1;
    else
        nQ0 = i;
    end
    qOut(:,:,i) =quantify(stateQuantification(:,:,nQ0), I(:,:,i));
end
for i=1:nImages
    [qTypes(:,:,i), array2Index] = makeQTypes(qOut(:,:,i));
end
[gridRow, gridCol] = find(ones(size(qOut(:,:,1))));

stateQuantification = qOut;
% permute qtypes from: DesignElement-QuantitationType-BioAssay 
% to : BioAssay-DesignElement-QuantitationType
qTypes = permute(qTypes, [3,1,2]);

