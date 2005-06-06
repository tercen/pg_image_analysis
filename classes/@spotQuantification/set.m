function q = set(q, varargin)
pArgin = varargin;

for i=1:2:length(pArgin)
    bInvalid = 0;
    if length(pArgin) < i+1
        error('set function expects property / value pairs as input');
    end
    prop = pArgin{i};
    val =  pArgin{i+1};
    switch prop
        case 'ID'
            q.ID = val;       
        case 'backgroundMethod'
            if isequal(val, 'interleaved')
               q.backgroundMethod = val;
            else
                bInvalid = 1;
            end
        case 'outlierMethod'
            if isequal(val, 'outlierMethod')
                q.outlierMethod = val;
            else
                bInvalid = 1;
            end
        case 'quantitationMetric'
            if isequal(val, 'mean')
                q.quantitationMetric = 'mean';
            elseif isequal(val,'median')
                q.quantitationMetric = 'median';
            else
                bInvalid = 1;
            end
        case 'background'
            if isnumeric(val) && length(val) == 1
                q.background = val;
            else
                bInvalid = 1;
            end
        case 'backgroundPercentiles'
            if isnumeric(val) && min(size(val)) == 1 && max(size(val)) == 2
                q.backgroundPercentiles = val;
            else
                bInvalid = 1;
            end
        case 'signal'
            if isnumeric(val) && length(val) == 1
                q.signal = val;
            else
                bInvalid = 1;
            end
                
          case 'signalPercentiles'
            if isnumeric(val) && min(size(val)) == 1 && max(size(val)) == 2
                q.signalPercentiles = val;
            else
                bInvalid = 1;
            end
        case 'backgroundDiameter'
            if isnumeric(val) && length(val) == 1
                q.backgroundDiameter = val;
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
