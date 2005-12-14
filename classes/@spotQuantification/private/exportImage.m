function exportImage(q, fName)
fid = fopen(fName, 'wt');
if fid == -1
    error('exportImage:fileError', '%s', ['Could not open: ', fName]);
end
fprintf(fid, '%s\n', '<General>');
fprintf(fid, '%s\t%s\n', 'File Name', fName);
fprintf(fid, '%s\t%s\n', 'Date', date);
fprintf(fid, '%s\t%s\n', 'Background Method', q(1,1).backgroundMethod);
fprintf(fid, '%s\t%f\n', 'Background Lower Percentile', q(1,1).backgroundPercentiles(1));
fprintf(fid, '%s\t%f\n', 'Background Upper Percentile', q(1,1).backgroundPercentiles(2));
fprintf(fid, '%s\t%d\n', 'Background Cell Diameter', q(1,1).backgroundDiameter); 
fprintf(fid, '%s\t%f\n', 'Signal Lower Percentile', q(1,1).signalPercentiles(1));
fprintf(fid, '%s\t%f\n', 'Signal Upper Percentile', q(1,1).signalPercentiles(2));
fprintf(fid, '%s\t%s\n', 'oOutlier', q(1,1).oOutlier);
fprintf(fid, '%s\n', '</General>');
fprintf(fid, '%s\n', '<Spots>');
[nRows, nCols] = size(q);
fprintf(fid, '%s\t', 'ID');
fprintf(fid, '%s\t', 'Row');
fprintf(fid, '%s\t', 'Column');
fprintf(fid, '%s\t', 'Mean Signal');
fprintf(fid, '%s\t', 'Mean Background');
fprintf(fid, '%s\t', 'Mean SigmBg');
fprintf(fid, '%s\t', 'Median Signal');
fprintf(fid, '%s\t', 'Median Background');
fprintf(fid, '%s\t', 'Median SigmBg');
fprintf(fid, '%s\t', 'X Grid');
fprintf(fid, '%s\t', 'Y Grid');
fprintf(fid, '%s\t', 'X offset');
fprintf(fid, '%s\t', 'Y offset');
fprintf(fid, '%s\t', 'Detected');
fprintf(fid, '%s\t', 'Diameter');
fprintf(fid, '%s\t', 'Threshold eff.');
fprintf(fid, '%s\t', 'Aspect Ratio');
fprintf(fid, '%s\t', 'Form Factor');
fprintf(fid, '%s\t', 'Ignored Pixels (%)');
fprintf(fid, '\n');

for i=1:nRows
    for j=1:nCols
        fprintf(fid, '%s\t', q(i,j).ID);
        fprintf(fid, '%d\t', i);
        fprintf(fid, '%d\t', j);
        fprintf(fid, '%f\t', q(i,j).meanSignal);
        fprintf(fid, '%f\t', q(i,j).meanBackground);
        fprintf(fid, '%f\t', q(i,j).meanSignal - q(i,j).meanBackground);
        fprintf(fid, '%d\t', q(i,j).medianSignal);
        fprintf(fid, '%d\t', q(i,j).medianBackground);
        fprintf(fid, '%d\t', q(i,j).medianSignal - q(i,j).medianBackground);
        sHok = size(q(i,j).binSpot); 
        cGrid = q(i,j).cLu + sHok/2;    
        fprintf(fid, '%f\t', q(i,j).cx);
        fprintf(fid, '%f\t', q(i,j).cy);
        if ~isempty(q(i,j).Centroid)              
            offset = q(i,j).Centroid - sHok/2;
            fprintf(fid, '%f\t', offset(1));
            fprintf(fid, '%f\t', offset(2));
        else
            fprintf(fid, '%s\t', 'NULL');
            fprintf(fid, '%s\t', 'NULL');
        end

        if q(i,j).isSpot
            det = 'TRUE';
        else
            det = 'FALSE';
        end
        fprintf(fid, '%s\t', det);
        fprintf(fid, '%f\t', q(i,j).Diameter);
        if ~isfield(get(q(i,j)), 'thrEff');
           eff = -1;
        else
            eff = q(i,j).thrEff;
        end
        fprintf(fid, '%f\t', eff);
        if ~isempty(q(i,j).AspectRatio)
            fprintf(fid, '%f\t', q(i,j).AspectRatio);
        else
            fprintf(fid, '%s\t', 'NULL');
        end
        if ~isempty(q(i,j).FormFactor)
            fprintf(fid, '%f\t', q(i,j).FormFactor);
        else
            fprintf(fid, '%s\t', 'NULL');
        end
        iOut = find(q(i,j).ignoredPixels);
        ignPerc = 100*length(iOut) / numel(q(i,j).ignoredPixels);
        fprintf(fid, '%f\t', ignPerc);
        fprintf(fid, '\n');
    end
end
fprintf(fid, '%s\n', '</Spots>');
fclose(fid);

            


