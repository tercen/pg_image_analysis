function fid = SetIniPars(iniName, iniPars);
fid = fopen(iniName, 'wt');
if (fid == -1)
    return;
end
clNames = fieldnames(iniPars);
for i=1:length(clNames)
    fieldstr = char(clNames(i));
    par = iniPars.(fieldstr);
    fprintf(fid, '%s',fieldstr);
    if (~isstr(par))
        % Use the adaptive formatting of the
        % MATLAB num2str function
        % Note that vector valued functions will be written as a string :
        % 1>2>3>4
        for n =1:length(par)
            fprintf(fid, '>%s', num2str(par(n)));
        end
    else
        fprintf(fid, '>%s', par);
    end
    fprintf(fid, '\n');
end
fclose(fid);
        