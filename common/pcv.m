function s = pcv(data)
% s = cvar(data)
% columnwise cv of data
s = std(data)./mean(data);