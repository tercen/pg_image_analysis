function [v,msg] = vLoad(fname);
% function v = vLoad(fname);
% will load the  file <fname> into structure v
% dispalys uigetfile when no fname is specified
% v will have m entries were m is the number of measurements
% each entry consists of n fields, where n is the number of headers in <filename> 
% to see a list of fields in v, use fieldnames(v)

if nargin == 0
   [sName, sPath] = uigetfile('*.v');
   if sName == 0
       return
   end
   fname = [sPath, '\', sName];

end
   


msg = [];
[fid, message] = fopen(fname, 'rt');
if (fid == -1)
    msg = message;
    v = [];
    return;
end
line = '';
% skip lines untill vBegin and
% read first (hdr) line
while ~isequal(line, 'vBegin')
    line = fgetl(fid);
end

line = fgetl(fid);
hdr = strread(line,'%s','delimiter','\t');



i = 0;
while (line ~= -1) 
    i = i+1;
    line = fgetl(fid);
    if isequal(line, 'vEnd')
        break;
    end
    if (line ~= -1)
        templ(i,:) = strread(line,'%s','delimiter','\t');
        for j = 1:length(templ(i,:))
            str = char(templ(i,j));
            val  = str2num(str);
            field = char(hdr(j));
            if ~isempty(val)
                v(i).(field) = val;        
            else
                v(i).(field) = str;
            end
            
            
        end
    end   
end
