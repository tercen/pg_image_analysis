function [r,c] = PS96_fname2rc(fname);
RowStr = ['A';'B';'C';'D';'E';'F';'G';'H'];
ColStr = ['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
r = strmatch(fname(1), RowStr);
c = strmatch(fname(2:3), ColStr);



