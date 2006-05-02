function [clHdr, data] = clHdrLoad(dFile)
[hdr, data] = hdrload(dFile);
clHdr = strread(hdr, '%s', 'delimiter', '\t');
% EOF
