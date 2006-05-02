function [v, vGen, refID] = cfGlobalQC(v, refID)
g = globalStats();
while(1)
    sOut = inputdlg('Please Set the Reference ID', 'Global QC', 1, cellstr(refID));
    if isempty(sOut)
        vGen = [];
        refID = [];
        break;
    else
         try
             [v, vGen] = vSetGlobalStats(g,v, char(sOut), 'EndLevel', 1);
             refID = char(sOut);
             break;
         catch
             [msg, errid] = lasterr;
            if ~isequal(errid, 'GlobalStats:IDNotFound')
                 error(msg);
             else
                 uiwait(errordlg(['ID not found: ', sOut], 'Error'));
             end
         end
    end
end

