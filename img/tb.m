% tb
bFile = 'G:\DataAnalysis\Bin\cBatch.bch';
template = 'G:\DataAnalysis\Bin\MK022_ii.tpl';
conf = 'G:\DataAnalysis\Bin\PG Settings.xml';
dP = 'C:\temp\tb';
disp('searching data ...')
fList = filehound(dP, '*.tiff');
nFiles = length(fList)
disp('batching')
[nFiles, msg]  = imgMakeBatchFileEx('GridOnLast', bFile, fList, conf, template)