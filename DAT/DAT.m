function varargout = DAT(varargin)
% DAT M-file for DAT.fig
%      DAT, by itself, creates a new DAT or raises the existing
%      singleton*.
%
%      H = DAT returns the handle to a new DAT or the handle to
%      the existing singleton*.
%
%      DAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAT.M with the given input arguments.
%
%      DAT('Property','Value',...) creates a new DAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help DAT

% Last Modified by GUIDE v2.5 19-Jul-2004 13:34:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAT_OpeningFcn, ...
                   'gui_OutputFcn',  @DAT_OutputFcn, ...
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


% --- Executes just before DAT is made visible.
function DAT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAT (see VARARGIN)

% Choose default command line output for DAT
handles.output = hObject;
IniPars.dataDir = 'C:\';
IniPars.templateDir = 'C:\';
IniPars.configDir = 'C:\';
IniPars.imgCommand = 'Imagene5';
IniPars.imgLocation = 'C:\Imagene\';
handles.iniFile = 'DAT.ini';
IniPars = getparsfromfile(handles.iniFile, IniPars);

handles.cOn = [225/255, 254/255, 255/255];
handles.cOff = [0.8, 0.8, 0.8];


set(findobj('Tag', 'stData'), 'BackgroundColor', handles.cOn);
set(findobj('Tag', 'pnData'),  'BackgroundColor', handles.cOn);
set(findobj('Tag', 'pbData'),   'Enable', 'on');

set(findobj('Tag', 'stTemplate'), 'BackgroundColor', handles.cOff);
set(findobj('Tag', 'pnTemplate'),  'BackgroundColor', handles.cOff);
set(findobj('Tag', 'pbTemplate'),   'Enable', 'off');

set(findobj('Tag', 'stConfig'), 'BackgroundColor', handles.cOff);
set(findobj('Tag', 'pnConfig'),  'BackgroundColor', handles.cOff);
set(findobj('Tag', 'pbConfig'),   'Enable', 'off');

set(findobj('Tag', 'pbAnalyse'), 'Enable', 'off');
% Update handles structure
handles.IniPars = IniPars;
guidata(hObject, handles);

% UIWAIT makes DAT wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function DAT_Close(hObject, eventdata, handles)
SetIniPars(handles.iniFile, handles.IniPars);
closereq;
% --- Outputs from this function are returned to the command line.
function varargout = DAT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbData.
function pbData_Callback(hObject, eventdata, handles)
% hObject    handle to pbData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = uigetdir(handles.IniPars.dataDir, 'Browse for data directory');
if isstr(dataDir)
    handles.IniPars.dataDir = dataDir;
    set(findobj('Tag', 'stData'), 'String', dataDir);
    set(findobj('Tag', 'stTemplate'), 'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pnTemplate'),  'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pbTemplate'),   'Enable', 'on');
else
    set(findobj('Tag', 'stData'), 'String', 'No data selected');
    
    set(findobj('Tag', 'stData'), 'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pnData'),  'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pbData'),   'Enable', 'on');

    set(findobj('Tag', 'stTemplate'), 'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pnTemplate'),  'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pbTemplate'),   'Enable', 'off');

    set(findobj('Tag', 'stConfig'), 'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pnConfig'),  'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pbConfig'),   'Enable', 'off');

    set(findobj('Tag', 'pbAnalyse'), 'Enable', 'off');
end
guidata(hObject, handles);

% --- Executes on button press in pbTemplate.
function pbTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to pbTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fName, pName] = uigetfile([handles.IniPars.templateDir,'\*.tpl'],'Select template file' );

if isstr(fName)
    handles.sTemplate       = [pName, '\', fName];
    handles.IniPars.templateDir     = pName;
    set(findobj('Tag', 'stTemplate'), 'String', fName);
    set(findobj('Tag', 'stConfig'), 'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pnConfig'),  'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pbConfig'),   'Enable', 'on');
else
     set(findobj('Tag', 'stTemplate'), 'String', 'No template selected');
    
    set(findobj('Tag', 'stConfig'), 'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pnConfig'),  'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pbConfig'),   'Enable', 'off');

    set(findobj('Tag', 'pbAnalyse'), 'Enable', 'off');
end
guidata(hObject, handles);
    
    
    
    % --- Executes on button press in pbConfig.
function pbConfig_Callback(hObject, eventdata, handles)
% hObject    handle to pbConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fName, pName] = uigetfile([handles.IniPars.configDir,'\*.ini'], 'Select configuration file');

if isstr(fName)
    handles.sConfig       = [pName, '\', fName];
    handles.IniPars.configDir     = pName;

    set(findobj('Tag', 'pbAnalyse'), 'Enable', 'on');
    set(findobj('Tag', 'stConfig'),'String', fName); 
else

    set(findobj('Tag', 'pbAnalyse'), 'Enable', 'off');
end
guidata(hObject, handles);
% --- Executes on button press in pbAnalyse.
function pbAnalyse_Callback(hObject, eventdata, handles)
% hObject    handle to pbAnalyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Enable', 'off')
set(gcf, 'Pointer', 'watch');
disp('Starting Data analysis sequence...');
sBatch = [handles.IniPars.dataDir,'\ImgBatchfile.bch'];
imgSetupBatch(handles.IniPars.dataDir, handles.sConfig, handles.sTemplate, sBatch);
drawnow;
cDir = pwd;
str = ['!',handles.IniPars.imgCommand,' -batch ',sBatch];
cd(handles.IniPars.imgLocation);
disp(str)
eval(str);
cd(cDir);
drawnow
imgCollectResults(sBatch, handles.IniPars.dataDir);

set(gcf, 'Pointer', 'arrow');
   set(findobj('Tag', 'stData'), 'String', 'No data selected');
    
    set(findobj('Tag', 'stData'), 'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pnData'),  'BackgroundColor', handles.cOn);
    set(findobj('Tag', 'pbData'),   'Enable', 'on');

    set(findobj('Tag', 'stTemplate'), 'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pnTemplate'),  'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pbTemplate'),   'Enable', 'off');

    set(findobj('Tag', 'stConfig'), 'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pnConfig'),  'BackgroundColor', handles.cOff);
    set(findobj('Tag', 'pbConfig'),   'Enable', 'off');

    set(findobj('Tag', 'pbAnalyse'), 'Enable', 'off');
