function value = get(q, strField)

clNames = fieldnames(q);
if nargin == 1
    for i=1:length(clNames)
        if ~isequal(clNames{i}, 'private')
            value.(clNames{i}) = q.(clNames{i});
        end
    end    
else
    
    for i=1:length(clNames)
        if isequal(strField, clNames{i}) & ~isequal(clNames{i}, 'private')
            value = q.(clNames{i});
            return
        end

    end
    error([strField, ' is not a valid and public spotQuantification property']);
end
    
