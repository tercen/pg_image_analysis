function g = set(g, varargin)
pArgin = varargin;

for i=1:2:length(pArgin)
    bInvalid = 0;
    if length(pArgin) < i+1
        error('set function expects property / value pairs as input');
    end
    prop = pArgin{i};
    val =  pArgin{i+1};
    switch prop
        case 'mask'
            if isnumeric(val)
                g.mask = val;
            else
                bInvalid = 1;
            end
        case 'spotPitch'
            if isnumeric(val) & length(val) <= 2
                g.spotPitch = val;
            else
                bInvalid = 1;
            end
        case 'spotSize'
            if isnumeric(val) & length(val) == 1
                g.spotSize = val;
            else
                bInvalid = 1;
            end
        case 'rotation'
            if isnumeric(val)
                g.rotation = val;
            else
                bInvalid = 1;
            end
        case 'method'
            if isequal(val, 'correlation2D')
                g.method = val;
            else
                bInvalid = 1;
            end
                
        otherwise
            error(['Invalid property: ', prop]);
    end
    if bInvalid
        error(['Invalid value for :',prop]);
    end
end
