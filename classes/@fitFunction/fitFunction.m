function f = fitFunction(strModel)

if nargin == 0 | ~ischar(strModel)
    f.strModel  = [];
    f.modelFunc = [];
    f.iniFunc   = [];
else
    Func = funcDef();
    [clList{1:length(Func)}] = deal(Func.strModelName);
    iMatch = strmatch(strModel, clList);
    if ~isempty(iMatch)
        f = Func(iMatch);
    else
        f.strModel =  [];
        f.modelFunc = [];
        f.iniFunc   = [];
    end
    
end
f = class(f, 'fitFunction');
    


    