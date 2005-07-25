function [v, annFields, msg] = vAnnotate96(v, annFile)
%function [v, annFields, msg] = vAnnotate96(v, annFile)
msg = [];
[a, msg]  = vReadAnnotation(annFile);
if isempty(a)
    return;
end


annFields = fieldnames(a);
annFields = annFields(3:end);

aFields = fieldnames(a);
iCol = strmatch('Col', aFields, 'exact');
iRow = strmatch('Row', aFields, 'exact');

if isempty(iCol) | isempty(iRow)
    msg = ['Annotation does not contain PS96 Row and Col attributes: ', annFile];
    return;
end
    
[clRow{1:length(a)}] = deal(a.Row);
[clCol{1:length(a)}] = deal(a.Col);
for i=1:length(v)
    for j = 1:length(a)
        if v(i).Index1 == a(j).Row & v(i).Index2 == a(j).Col
            x = find( [1:length(aFields)] ~= iRow & [1:length(aFields)] ~= iCol);
            for n = 1:length(x)
                strField = aFields{x(n)};
                v(i).(strField) = a(j).(strField);
            end
            break
        end
    end
end

            
    