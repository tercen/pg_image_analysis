function varargout = AdvancedSettings(varargin)
% ADVANCEDSETTINGS M-file for AdvancedSettings.fig
%      ADVANCEDSETTINGS, by itself, creates a new ADVANCEDSETTINGS or raises the existing
%      singleton*.
%
%      H = ADVANCEDSETTINGS returns the handle to a new ADVANCEDSETTINGS or the handle to
%      the existing singleton*.
%
%      ADVANCEDSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCEDSETTINGS.M with the given input arguments.
%
%      ADVANCEDSETTINGS('Property','Value',...) creates a new ADVANCEDSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AdvancedSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AdvancedSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AdvancedSettings

% Last Modified by GUIDE v2.5 26-Apr-2003 17:17:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AdvancedSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @AdvancedSettings_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AdvancedSettings is made visible.
function AdvancedSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AdvancedSettings (see VARARGIN)

% Choose default command line output for AdvancedSettings
handles.output = hObject;
handles.bPressed = 'Cancel';
% Update handles structure
handles.strMethod   = char(varargin{1});
handles.Tolerance   = varargin{2};
handles.offsetX     = varargin{3};
handles.offsetY     = varargin{4};
handles.MaxFunEvals = varargin{5};
if isequal(handles.strMethod, 'Robust')
    set(findobj('Tag','rbRobust'), 'Value',1);
    set(findobj('Tag', 'rbFast'), 'Value',0);
else
     set(findobj('Tag','rbRobust'), 'Value',0);
    set(findobj('Tag', 'rbFast'), 'Value',1);
end

set(findobj('Tag','edTolerance'), 'String',num2str(handles.Tolerance));
set(findobj('Tag','edXoff'), 'String',num2str(handles.offsetX));
set(findobj('Tag','edYoff'), 'String',num2str(handles.offsetY));
set(findobj('Tag','edMaxEvals'), 'String',num2str(handles.MaxFunEvals));

guidata(hObject, handles);

% UIWAIT makes AdvancedSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AdvancedSettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rbFast.
function rbFast_Callback(hObject, eventdata, handles)
% hObject    handle to rbFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbFast
set(hObject, 'Value', 1);
set(findobj('Tag', 'rbRobust'), 'Value', 0);

% --- Executes on button press in rbRobust.
function rbRobust_Callback(hObject, eventdata, handles)
% hObject    handle to rbRobust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbRobust
set(hObject, 'Value', 1);
set(findobj('Tag', 'rbFast'), 'Value', 0);

% --- Executes during object creation, after setting all properties.
function edTolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edTolerance_Callback(hObject, eventdata, handles)
% hObject    handle to edTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edTolerance as text
%        str2double(get(hObject,'String')) returns contents of edTolerance as a double
val = str2double(get(hObject, 'String'));
if isnan (val)
    set(hObject, 'String', num2str(handles.Tolerance));
else
    handles.Tolerance = val;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edXoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edXoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edXoff_Callback(hObject, eventdata, handles)
% hObject    handle to edXoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edXoff as text
%        str2double(get(hObject,'String')) returns contents of edXoff as a double
val = str2double(get(hObject, 'String'));
if isnan (val)
    set(hObject, 'String', num2str(handles.offsetX));
else
    handles.offsetX = val;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edYoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edYoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edYoff_Callback(hObject, eventdata, handles)
% hObject    handle to edYoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edYoff as text
%        str2double(get(hObject,'String')) returns contents of edYoff as a double
val = str2double(get(hObject, 'String'));
if isnan (val)
    set(hObject, 'String', num2str(handles.offsetY));
else
    handles.offsetY = val;
end
guidata(hObject, handles);

% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf, 'Visible', 'off');
handles.bPressed = 'Cancel';
guidata(hObject, handles);
% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gcf, 'Visible', 'off');
handles.bPressed    = 'OK';
hrbRobust = findobj('Tag', 'rbRobust');
mVal = get( hrbRobust, 'Value');
if mVal == 1
    handles.strMethod = 'Robust';
else
    handles.strMethod = 'Normal';
end

    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edMaxEvals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMaxEvals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edMaxEvals_Callback(hObject, eventdata, handles)
% hObject    handle to edMaxEvals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edMaxEvals as text
%        str2double(get(hObject,'String')) returns contents of edMaxEvals as a double
val = str2double(get(hObject, 'String'));
if isnan (val)
    set(hObject, 'String', num2str(handles.MaxFunEvals));
else
    handles.MaxFunEvals = val;
end
guidata(hObject, handles);

