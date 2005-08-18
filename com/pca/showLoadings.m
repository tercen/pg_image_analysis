function showLoadings(nComponents)
global data
global loadings
global scores
global relVariation
global idVariable
global idCondition

if isempty(loadings)
    error('loadings have not been calculated');
end

nComponents = min(nComponents, size(loadings,2));
figure
for i = 1:nComponents
    subplot(nComponents,1,i)
    plot(loadings(:,i))
    title(['pc',num2str(i),' ',num2str(100*relVariation(i)),'%']);
end
