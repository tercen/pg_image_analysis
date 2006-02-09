function varargout = gfSettings(varargin)
% GFSETTINGS M-file for gfSettings.fig
%      GFSETTINGS, by itself, creates a new GFSETTINGS or raises the existing
%      singleton*.
%
%      H = GFSETTINGS returns the handle to a new GFSETTINGS or the handle to
%      the existing singleton*.
%
%      GFSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GFSETTINGS.M with the given input arguments.
%
%      GFSETTINGS('Property','Value',...) creates a new GFSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gfSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gfSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gfSettings

% Last Modified by GUIDE v2.5 06-Jan-2006 20:29:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gfSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @gfSettings_OutputFcn, ...
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


% --- Executes just before gfSettings is made visible.
function gfSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gfSettings (see VARARGIN)

% Choose default command line output for gfSettings
handles.output = hObject;
handles.settings = [];
% Update handles structure
guidata(hObject, handles);


for i = 1:2:length(varargin)
    if length(varargin) < i+1
        error('varargin should be property/val pairs');
    end
    prop = varargin{i};
    val = varargin{i+1};
    switch prop
        case 'method'
            if isequal(val, 'correlation2D')
                set(handles.puMethod, 'value', 1);
            else
                error('unknown option for method');
            end
        case 'contrast'
            if isequal(val, 'linear')
                set(handles.puContrast, 'value', 1);
            elseif isequal(val, 'equal')
                set(handles.puContrast, 'value', 2);
            else
                error('unknown option for contrast');
            end
        case 'series'
            if isequal(val, 'fixed')
                set(handles.puSeriesBehavior, 'value', 1);
            elseif isequal(val, 'adapt')
                set(handles.puSeriesBehavior, 'value', 2);
            else
                error('unknown option for series behavior');
            end
        case 'useRefs'
            if val
                set(handles.cbUseRefs, 'value', 1);
            else
                set(handles.cbUseRefs, 'value', 0);
            end
    end            

end


% UIWAIT makes gfSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gfSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.settings;

% --- Executes on selection change in puMethod.
function puMethod_Callback(hObject, eventdata, handles)
% hObject    handle to puMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puMethod


% --- Executes during object creation, after setting all properties.
function puMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in puSeriesBehavior.
function puSeriesBehavior_Callback(hObject, eventdata, handles)
% hObject    handle to puSeriesBehavior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puSeriesBehavior contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puSeriesBehavior


% --- Executes on selection change in puContrast.
function puContrast_Callback(hObject, eventdata, handles)
% hObject    handle to puContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puContrast contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puContrast


% --- Executes during object creation, after setting all properties.
function puContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbApply.
function pbApply_Callback(hObject, eventdata, handles)
% hObject    handle to pbApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.puMethod, 'value');
str = get(handles.puMethod, 'String');
handles.settings.method = str;
val = get(handles.puContrast, 'value');
str = get(handles.puContrast, 'string');
handles.settings.contrast = str{val};
val = get(handles.puSeriesBehavior, 'value');
str = get(handles.puSeriesBehavior, 'string');
handles.settings.series = str{val};
val = get(handles.cbUseRefs, 'value');
handles.settings.useRefs = val;
guidata(hObject, handles);
closereq;

% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.settings = [];
guidata(hObject, handles);
closereq;

% --- Executes on button press in cbUseRefs.
function cbUseRefs_Callback(hObject, eventdata, handles)
% hObject    handle to cbUseRefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbUseRefs


