function varargout = gridManager(varargin)
% GRIDMANAGER M-file for gridManager.fig
%      GRIDMANAGER, by itself, creates a new GRIDMANAGER or raises the existing
%      singleton*.
%
%      H = GRIDMANAGER returns the handle to a new GRIDMANAGER or the handle to
%      the existing singleton*.
%
%      GRIDMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRIDMANAGER.M with the given input arguments.
%
%      GRIDMANAGER('Property','Value',...) creates a new GRIDMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gridManager_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gridManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gridManager

% Last Modified by GUIDE v2.5 17-Jun-2005 22:30:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gridManager_OpeningFcn, ...
                   'gui_OutputFcn',  @gridManager_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gridManager is made visible.
function gridManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gridManager (see VARARGIN)

handles.iniFile = 'gridManager.ini';
iniPars.dataDir = 'C:\';
iniPars.templateDir = pwd;
iniPars.dftInstrument = 'detect';
iniPars.xResize = 256;
iniPars.yResize = 256;
iniPars.gridRefMarker = '#';
handles.iniPars = getparsfromfile(handles.iniFile, iniPars);
handles.list = [];
handles.selectedWell = [];
handles.gridMode = 'kinLast';
% Choose default command line output for gridManager
handles.output = hObject;
handles.oArray = [];
handles.template = [];
handles.oArray = array();
set(gcf, 'position', [6.4 7.07692 95.4 29.3846]);
% Update handles structure
set(handles.pbAll, 'enable', 'off');
set(handles.pbThis, 'enable', 'off');



guidata(hObject, handles);

% UIWAIT makes gridManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function Close(hObject, eData, handles)
SetIniPars(handles.iniFile, handles.iniPars);
closereq;
% --- Outputs from this function are returned to the command line.
function varargout = gridManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbThis.
function pbThis_Callback(hObject, eventdata, handles)
% hObject    handle to pbThis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

instrumentFile = [handles.instrument,'.instrument'];
try
    instrumentPars = readInstrumentParameters(instrumentFile);
catch
    errordlg(lasterr);
    return
end
names = fieldnames(instrumentPars);
for i=1:length(names)
    if isempty(instrumentPars.(names{i}))
        errordlg('Instrument parameters were not properly initalized');
        return;
    end
end
handles.bShow = 1;

handles = analyze(hObject, handles, instrumentPars);
guidata(hObject, handles);


% --- Executes on button press in pbAll.
function pbAll_Callback(hObject, eventdata, handles)
% hObject    handle to pbAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miLoadSet_Callback(hObject, eventdata, handles)
% hObject    handle to miLoadSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newDir = uigetdir(handles.iniPars.dataDir, 'Please, select a data set.');
if newDir
    handles.iniPars.dataDir = newDir;
    try
        oData = dataSet('path', newDir, 'instrument', handles.iniPars.dftInstrument);
        set(gcf, 'pointer', 'watch');
        drawnow;
        oData = getList(oData);
        list = get(oData, 'list');
        set(handles.stData, 'string', newDir);
        
        handles.list = list;
        handles.instrument = get(oData, 'instrument');
       
    catch
        set(gcf, 'pointer', 'arrow');
        errstr = lasterr;
        errordlg(lasterr,'Load Failed !!!');
    end
end
arrays = initializeDataSet(list, handles.instrument);
arrays = initializeGraph(handles.axes1, arrays);
handles.arrays = arrays;
set(gcf, 'pointer', 'arrow');
drawnow;
guidata(hObject, handles); 
  
        
  


% --------------------------------------------------------------------
function miData_Callback(hObject, eventdata, handles)
% hObject    handle to miData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miGrid_Callback(hObject, eventdata, handles)
% hObject    handle to miGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function miQuantification_Callback(hObject, eventdata, handles)
% hObject    handle to miQuantification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miAbout_Callback(hObject, eventdata, handles)
% hObject    handle to miAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function well_Callback(hObject, eventData, handles)
wells = handles.arrays;

[i,j] = findCallingWell(hObject, wells);
if ~wells(i,j).used
    return
end

if ~isempty(handles.selectedWell)
    iOld  = handles.selectedWell(1);
    jOld  = handles.selectedWell(2);
    if isempty(wells(iOld, jOld).oS)
        strColor = 'k';
    else
        strColor = 'g';
    end
    set(wells(iOld, jOld).hPlot, 'color', strColor, 'markerfacecolor', 'w')
    
end
if ~isempty(handles.template)
    set(handles.pbAll, 'enable', 'on');
    set(handles.pbThis, 'enable', 'on');
end

handles.selectedWell = [i,j];

set(wells(i,j).hPlot, 'markerfacecolor', [0.7, 0.3, 1]);
set(handles.stWell, 'String', wells(i,j).id);
guidata(hObject, handles); 

function [i,j] = findCallingWell(hCalling, wells)
[nRows, nCols] = size(wells);
for i=1:nRows
    for j=1:nCols
        if hCalling == wells(i,j).hPlot;
            return
        end
    end
end                
            
function arrays = initializeDataSet(list, instrument)


switch instrument
    case 'PS96'
        wells = ones(12,8);
        strRow = ['ABCDEFGH'];
        strCol = ['01';'02';'03';'04';'05';'06';'07';'08';'09'; '10'; '11'; '12'];
        wList = vGetUniqueID(list, 'W');
        for i=1:length(strRow)
            for j=1:size(strCol,1)
                strID = ['W',strRow(i), strCol(j,:)];
                if ~isempty(strmatch(strID, wList))
                    arrays(i,j).used = 1;
                    arrays(i,j).id = strID;
                    arrays(i,j).oS   = [];
                    arrays(i,j).oQ   = [];
                else
                    arrays(i,j).used = 0;
                end
            end
        end
    case 'PS4';
        wells = ones(4,1);
        [nRows, nCols] = size(wells);
        row = [1:4];
        wList = vGetUniqueID(list, 'W');
        for i = 1:nRows
            strID = ['W', num2str(i)];
            if ~isempty(strmatch(strID, wList));
                arrays(i).used = 1;
                arrays(i).id = strID;
                arrays(i).oS = [];
                arrays(i).oQ = [];
            else
                arrays(i).used = 0;
            end
        end
        
      

    otherwise
        error('unsupported instrument');
end

function arrays = initializeGraph(hAx, arrays)
[nRows, nCols] = size(arrays);

axes(hAx);
hold off
axis([0 13 0 9]);
hold on
for i=1:nRows
    for j=1:nCols
        h(i,j) = plot(hAx, j,nRows + 1 -  i, 'ko', 'markersize', 12);
        arrays(i,j).hPlot = h(i,j);
        if ~arrays(i,j).used
            set(h(i,j), 'marker', 'x')
        end
    end
end
set(h, 'ButtonDownFcn', 'gridManager(''well_Callback'',gcbo,[],guidata(gcbo))');
set(hAx, 'visible', 'on','xtick', [], 'ytick', [], 'box', 'on');




% --------------------------------------------------------------------
function miGridMode_Callback(hObject, eventdata, handles)
% hObject    handle to miGridMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miKinLast_Callback(hObject, eventdata, handles)
% hObject    handle to miKinLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinFirst, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
handles.gridMode = 'kinLast';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miKinFirst_Callback(hObject, eventdata, handles)
% hObject    handle to miKInFirst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
handles.gridMode = 'kinFirst';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miEndPoint_Callback(hObject, eventdata, handles)
% hObject    handle to miEndPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miKinFirst, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
% --------------------------------------------------------------------
function miAll_Callback(hObject, eventdata, handles)
% hObject    handle to miAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miKinFirst, 'checked', 'off');



% --------------------------------------------------------------------
function miLoadTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to miLoadTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curDir = pwd;
cd(handles.iniPars.templateDir);
[fName, pathName] = uigetfile('*.txt', 'Please, select a template file');
cd(curDir);
if fName
    handles.iniPars.templateDir = pathName;
    handles.template = fName;

    [handles.oArray, handles.clID] = fromFile(handles.oArray, [pathName, '\', fName], handles.iniPars.gridRefMarker);
    
    if ~isempty(handles.selectedWell)
        set(handles.pbAll, 'enable', 'on');
        set(handles.pbThis, 'enable', 'on');
    end

end

guidata(hObject, handles);
    
function handles = analyze(hObject, handles, instrumentPars);

set(gcf, 'pointer', 'watch');
drawnow
% find selected well entries
currentArray = handles.arrays(handles.selectedWell(1), handles.selectedWell(2));
[wellList{1:length(handles.list)}] = deal(handles.list.W);
iCurrent = strmatch(currentArray.id, wellList); 
currentList = handles.list(iCurrent);
nImages = length(currentList);
stString = ['Loading ',num2str(nImages), ' for well ',currentArray.id];
set(handles.stStatus, 'String', stString);
drawnow
rSize = [handles.iniPars.xResize, handles.iniPars.yResize];
try
    for i=1:nImages
        I(:,:,i) = imread([currentList(i).path, '\', currentList(i).name]);
        pump  = char(currentList(i).P);
        c(i) = str2num(pump(2:end));
    end
catch
    errordlg(lasterr, currentArray.id);
    return
end
[c, iSort] = sort(c);
I = I(:,:,iSort);

set(handles.stStatus, 'String', 'Analyzing');
drawnow;
time = clock;
switch handles.gridMode

    case 'kinLast'
        try 
            [x,y,oS, oQ] = gridKinetics(I, nImages, handles.oArray, instrumentPars, rSize, handles.clID);
        catch
            errordlg(lasterr);
            set(gcf, 'pointer', 'arrow');
            return;
        end
        
        case 'kinFirst'
        
end
currentArray.oQ = oQ;
currentArray.oS = oS;
handles.arrays(handles.selectedWell(1), handles.selectedWell(2)) = currentArray;

set(gcf, 'pointer', 'arrow');
stString = ['Ready (',num2str(etime(clock, time)),'s)'];
set(handles.stStatus, 'String', stString);
if handles.bShow
    hp = presenter(I,x,y,oS,oQ,c);
    set(hp, 'name', currentArray.id);
end


