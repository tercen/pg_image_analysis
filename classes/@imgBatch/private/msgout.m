function msgout(fid, msgline)
    if fid > 0
        fprintf(fid, '%s\n', msgline);
    end
    