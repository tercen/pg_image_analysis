function export(q, strMethod, fName, xas)
% function spotQuantification.export(q, strMethod, location, xas)
switch strMethod
    case 'kinetics'
        exportKinetics(q, fName, xas)
    otherwise
        error(['unknown export method: ',strmethod]);
end
