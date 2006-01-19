function s = shift(s, xyShift)
% function s = shift(s, xyShift)
for i=1:length(s(:))
    if ~isempty(s(i).cLu)
        nLu = s(i).cLu + xyShift;
        nLu(1) = max(1, nLu(1)); nLu(2) = max(1, nLu(2));
        s(i).cLu = nLu;
    end
end
% EOF