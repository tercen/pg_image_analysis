function pdf = pdfChiSqr(x,v, k, A)

if nargin < 3
    k = 1;
    A = 1;
end

pdf = (k*x).^( (v-2)/2 ) .* exp(-(k*x)/2) / (2^(v/2) * gamma(v/2));
pdf = A*pdf;