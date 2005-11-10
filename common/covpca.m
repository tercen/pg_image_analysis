function [pc, scores, latent] = covpca(X)
X = X -repmat(mean(X), size(X,1),1);
[scores, ew] = eig(cov(X));
[latent, iSort] = sort(diag(ew),1, 'descend');
scores = scores(:, iSort);
pc = (scores' * X')';
%EOF
