function preProcessExe(p, src, dst)

if ischar(dst)
    preProcessSingle(p, src, dst);
end
