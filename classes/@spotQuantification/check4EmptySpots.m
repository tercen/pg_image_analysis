function q = check4EmptySpots(q, checkMode)

if nargin == 1
    checkMode = 'all';
end

switch checkMode
    case 'segmentation'
        q = checkForEmptySegmentation(q);
    case 'quantification'
        q = checkForEmptyQuantification(q);
    case 'all'
        q = checkForEmptySegmentation(q);
        q = checkForEmptyQuantification(q);
    otherwise
        error('Invalid value for imput argument checkMode')
end

function q = checkForEmptySegmentation(q)
for i = 1:length(q(:))
    os = q(i).oSegmentation;
    if isempty(get(os, 'bsSize'))
        error('Error while checking for empty spot: segmentation was not set')
    end
    if isempty(get(os, 'bsTrue'))
        q(i).isEmpty = true;
    end
end

function q = checkForEmptyQuantification(q)
pMaxEmpty = 1e-4;
for i = 1:length(q(:))
    if isempty(q(i).pSignal)
        error('Error while checking for empty spot: quantification was not set')
    end
    if q(i).pSignal > pMaxEmpty
        q(i).isEmpty = true;
    end
end
    




            


