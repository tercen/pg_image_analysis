function [pc, scores, latent] = corpca(X);
X = X -repmat(mean(X), size(X,1),1);
[scores, ew] = eig(corrcoef(X));
[latent, iSort] = sort(diag(ew),1, 'descend');
scores = scores(:, iSort);
pc = (scores' * X')';
%EOF