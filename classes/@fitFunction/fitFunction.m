function f = fitFunction(strModel)

if nargin == 0 | ~ischar(strModel)
    f.strModelName  = [];
    f.strModelDescription = [];
    f.clParameter   = [];
    f.strFitFunctionName = [];
    f.strIniFunctionName = [];
    f.jacFlag = 0;
    
else
    Func = funcDef();
    [clList{1:length(Func)}] = deal(Func.strModelName);
    iMatch = strmatch(strModel, clList);
    if ~isempty(iMatch)
        f = Func(iMatch);
    else
        f.strModelName  = [];
        f.strModelDescription = [];
        f.clParameter   = [];
        f.strFitFunctionName = [];
        f.strIniFunctionName = [];
        f.jacFlag = 0;
    end
    
end
f = class(f, 'fitFunction');
