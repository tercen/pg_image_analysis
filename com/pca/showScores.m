function showScores(nComponents)
global data
global loadings
global scores
global relVariation
global idVariable
global idCondition

nComponents = max(3, nComponents);
nComponents = min(2, nComponents);

if isempty(scores)
    error('scores have not been calculated');
end

figure
% 2D or 3D plot the scores, as required 
if nComponents == 2
    for i = 1:size(scores,1)
        h(i) = plot(scores(i,1), scores(i,2), '.');
        hold on
    end
    xlabel(['pc1 ',num2str(100* relVariation(1)), '%']);
    ylabel(['pc2 ',num2str(100 *relVariation(2)), '%']);
else
    for i = 1:size(scores,1)
        h(i) = plot3(scores(i,1), scores(i,2),scores(i,3), '.');
        hold on
    end
    xlabel(['pc1 ',num2str(100 *relVariation(1)), '%']);
    ylabel(['pc2 ',num2str(100 *relVariation(2)), '%']);
    zlabel(['pc3 ',num2str(100 *relVariation(3)), '%']);
end


% if idCondition is defined color code according to condition


if ~isempty(idCondition)
    if length(idCondition) ~= size(scores,1)
        error('Incorrect number of condition id');
    end
    
    if ischar(idCondition)
        idCondition = cellstr(idCondition);
    end
    [uCondition, classLabel]  = clGetUniqueID(idCondition);
    cMap = colormap('jet');
    cStep = floor(length(cMap)/length(uCondition));
    for i=1:length(uCondition)
        iColor = 1 + (i-1) * cStep;
        g = h(classLabel == i);
        G(i) = g(1);
        set(g, 'color', cMap(iColor,:))
        
    end
    legend(G, uCondition, 'location', 'NorthEastOutside')
end


        
    
     


    
