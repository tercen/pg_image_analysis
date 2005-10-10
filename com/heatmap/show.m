function show(data)
global RowLabels
global ColLabels
global RowLabelPosition
global ColLabelPosition
global showColorBar

if isempty(showColorBar)
    showColorBar = true;
end    

imagesc(data);
if showColorBar
    colorbar;
end


if ~isempty(RowLabels)
    set(gca, 'YTickLabel', RowLabels);
else
    set(gca, 'YTick', [])
end

if ~isempty(ColLabels)
    set(gca, 'XTickLabel', ColLabels);
else
    set(gca, 'XTick', []);
end

if ~isempty(RowLabelPosition)
    set(gca, 'Ytick', RowLabelPosition);
end
if ~isempty(ColLabelPosition)
    set(gca, 'XTick', ColLabelPosition);
end
