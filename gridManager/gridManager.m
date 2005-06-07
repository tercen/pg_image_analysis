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

% Last Modified by GUIDE v2.5 07-Jun-2005 23:01:18

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
iniPars.instrument = 'PS96';


handles.iniPars = getparsfromfile(handles.iniFile, iniPars);
handles.list = [];

% Choose default command line output for gridManager
handles.output = hObject;

% Update handles structure
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
        oData = dataSet('path', newDir, 'instrument', handles.iniPars.instrument);
        set(gcf, 'pointer', 'watch');
        list = getList(oData);
        set(gcf, 'pointer', 'arrow');
        handles.list = list;
    catch
        set(gcf, 'pointer', 'arrow');
        errstr = lasterr;
        errordlg(lasterr,'Load Failed !!!');
    end
end
guidata(hObject, handles);   
        
  


% --------------------------------------------------------------------
function miData_Callback(hObject, eventdata, handles)
% hObject    handle to miData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function mSettings_Callback(hObject, eventdata, handles)
% hObject    handle to mSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miInstrument_Callback(hObject, eventdata, handles)
% hObject    handle to miInstrument (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miPS96_Callback(hObject, eventdata, handles)
% hObject    handle to miPS96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miPS4_Callback(hObject, eventdata, handles)
% hObject    handle to miPS4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miFD10_Callback(hObject, eventdata, handles)
% hObject    handle to miFD10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


