function [Pars, fid] = getparsfromfile(iniFile, Pars)
% [Pars, fid] = getparsfromfile(iniFile, Pars)
% functin retrieves parameters from an ascii (ini)file
% the file is assumed th have lines in the following format:
% ParName>ParValue
% getparsfromfile will look for fieldnames in the structure Pars to get
% ParName and match parvalue when found.
% ParValue will be of the same type as the value in Pars on input (char or
% num)
% When ParName is not found in the specified file the value on input is
% coupled to the output structure Pars.
% When ParValue cannot be converted to the input type (char -> num)
% the value specified on input will be copied to output.
% When the inifile cannot be opened, 
% the Pars on input wil just be copied to output
% in this case fid will be -1
% any entries not delimited with > are skipped / as will be delimted values
% appearing after the first one.
%
% EXAMPLE
%
% consider a file named inifile.ini
% with ascii contents looking like:
% 
% Inifile for program
% initialDir>C:\temp
% numberOfCalls>3>4
%
% code may be:
% % set defaults
% IniPars.initialDir = 'C:\data';
% IniPars.numberOfCalls = 5;
% IniPars.nIterations = 500;
%
% ParsFromFile = getparsfromfile('file.ini',IniPars);
%
% Result
% IniPars.initialDir = 'C:\temp'
% IniPars.numberOfCalls = 3
% IniPars.nIterartions = 500 (not in ini file so take input value
% (default))
%

fid = fopen(iniFile, 'rt');
if (fid == -1), return, end
clFieldNames = fieldnames(Pars);

while(1)
    line = fgetl(fid);
    if (line == -1)
        break;
    end
    clLine = strread(line, '%s', 'delimiter', '>');
    if (length(clLine)>1)
        iMatch = strmatch(clLine(1), clFieldNames, 'exact');
        if (~isempty(iMatch))
            if isnumeric(Pars.(char(clFieldNames(iMatch))))
                % read in as scalar or vector
                for nElement = 2:length(clLine)
                    Val(nElement-1) = str2num(clLine{nElement});
                   
                end

            else
                Val = char(clLine(2));
            end
            if ~isempty(Val), Pars.(char(clFieldNames(iMatch))) = Val; end
        end
    end
end
fclose(fid);