function oq = spotQuantification(s, I, cx, cy, varargin);

if length(varargin) == 1
    % use existing object
    bIn = varargin{1};
    if isa(bIn, 'spotQuantification');
        oq = bIn;
        return;
    else
        error(['5th argument must be a spotQuantification object']);
    end
else

    spots = get(s, 'spots');
    [nRows, nCols] = size(spots);
    for i=1:nRows
        for j=1:nCols
            q(i,j) = spots(i,j);
        end
    end
    
    for i=1:nRows
        for j=1:nCols            
            q(i,j).backgroundMethod     = 'interleaved';
            q(i,j).outlierMethod        = 'none';
            q(i,j).quantitationMetric   = 'median';
            q(i,j).background = [];
            q(i,j).backgroundPercentiles = [0.01, 0.99];
            q(i,j).signal = [];
            q(i,j).signalPercentiles = [0.1, 0.98];
            q(i,j).ignoredPixels = [];
            q(i,j).backgroundDiameter = 4;    
            %oq(i,j) = class(q(i,j), 'spotQuantification');
            %if length(varargin) > 1
             %   oq(i,j) = set(oq(i,j), varargin{:});
            %end
        end

    end

    oq = class(q, 'spotQuantification');
     for i=1:nRows
        for j=1:nCols            
            if length(varargin) > 1
               oq(i,j) = set(oq(i,j), varargin{:});
               
            end
        end

     end
    
end
oq = quantify(oq, I, cx, cy);
