function v= vResetFlags(v)
for i=1:length(v)
    v(i).QcFlag = 0;
end
