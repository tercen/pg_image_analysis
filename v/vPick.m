function clList = vPick(v, strID);
% clList = vPick(v, strID)
% SEE vArrange96, vMap96
h = vPickList(v, strID);
waitfor(h, 'Visible');
handles = guidata(h);
delete(h);
clList = handles.strList;
