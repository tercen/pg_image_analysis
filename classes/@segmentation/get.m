function value = get(s, strField)

clNames = fieldnames(s);
if nargin == 1
    for i=1:length(clNames)
        if ~isequal(clNames{i}, 'private')
            value.(clNames{i}) = s.(clNames{i});
        end
    end    
else
    
    for i=1:length(clNames)
        if isequal(strField, 'binSpot')
            value = getBinSpot(s);
            return
        elseif isequal(strField, clNames{i}) & ~isequal(clNames{i}, 'private')
            value = s.(clNames{i});
            return
        end

    end
    error([strField, ' is not a valid and public segmentation property']);
end
    
