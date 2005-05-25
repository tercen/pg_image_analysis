function s = set(s, varargin)
pArgin = varargin;

for i=1:2:length(pArgin)
    bInvalid = 0;
    if length(pArgin) < i+1
        error('set function expects property / value pairs as input');
    end
    prop = pArgin{i};
    val =  pArgin{i+1};
    switch prop
        case 'method'
            if isequal(val, 'threshold1')
               s.method = val;
            else
                bInvalid = 1;
            end
        case 'rotation'
            if isnumeric(val) & length(val) == 1
                s.rotation = val;
            else
                bInvalid = 1;
            end
        case 'spotAreaSize'
              if isnumeric(val) & length(val) == 1
                s.spotAreaSize  = val;
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
