function p = pgFit(model)

f = fitFunction(model);
if isempty(get(f, 'strModelName'))
    error([model, ' is not an available model for use with pgFit objects']);
end
p.modelName = model;
p.modelObj  = f;
p.iniPars   = [];
p.lbPars    = [];
p.ubPars    = [];
p.fitMethod = 'Normal';
p.robTune   = 1;

if get(f, 'jacFlag')
    p.jacobian  = 'on';
else
    p.jacobian = 'off';
end

p.xOffset   = 0;
p.maxIterations = 100;
p.TolX = 1e-2;
p.TolMode = 'Relative';
p = class(p, 'pgFit');