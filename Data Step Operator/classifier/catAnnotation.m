function txt = catAnnotation(annotation)
annotation = cellfun(@cnv, annotation, 'uni', false);
for i = 1:size(annotation,1)
    txt(i) = cellstr(horzcat(annotation{i,:}));
end
%