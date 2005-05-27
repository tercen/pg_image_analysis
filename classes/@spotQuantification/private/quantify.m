function oq = quantify(oq, I, cx, cy)
methodStr = oq(1,1).backgroundMethod;
switch methodStr
    case 'interleaved'
        bg = backgroundInterleaved(oq, I, cx, cy);
end
