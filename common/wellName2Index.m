function [row, col] = wellName2Index(strWellName);

row = str2double(char(double(strWellName(1)) - 16));
col = str2double(strWellName(2:end));
