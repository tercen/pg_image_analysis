function y = pp(y)
s = size(y);
for i=1:s
    y(:,i) = y(:,i) - median(y(:,i));
end
y = y/std2(y);