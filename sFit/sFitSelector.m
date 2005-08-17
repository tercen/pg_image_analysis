function varargout = sFitSelector(varargin)
% SFITSELECTOR M-file for sFitSelector.fig
%      SFITSELECTOR, by itself, creates a new SFITSELECTOR or raises the existing
%      singleton*.
%
%      H = SFITSELECTOR returns the handle to a new SFITSELECTOR or the handle to
%      the existing singleton*.
%
%      SFITSELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SFITSELECTOR.M with the given input arguments.
%
%      SFITSELECTOR('Property','Value',...) creates a new SFITSELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sFitSelector_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sFitSelector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sFitSelector

% Last Modified by GUIDE v2.5 16-Aug-2005 14:09:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sFitSelector_OpeningFcn, ...
                   'gui_OutputFcn',  @sFitSelector_OutputFcn, ...
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


% --- Executes just before sFitSelector is made visible.
function sFitSelector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sFitSelector (see VARARGIN)

% Choose default command line output for sFitSelector
spotID = varargin{1};
annotations = varargin{2};
set(handles.lbSubstrate, 'String', spotID);
norID = [{'#NONE'}, spotID];
set(handles.lbNormalizer, 'String', norID);
set(handles.lbGrouping, 'String', annotations);
set(handles.lbSeries, 'String', annotations);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes sFitSelector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sFitSelector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lbSubstrate.
function lbSubstrate_Callback(hObject, eventdata, handles)
% hObject    handle to lbSubstrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbSubstrate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbSubstrate


% --- Executes during object creation, after setting all properties.
function lbSubstrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbSubstrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lbNormalizer.
function lbNormalizer_Callback(hObject, eventdata, handles)
% hObject    handle to lbNormalizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbNormalizer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbNormalizer


% --- Executes during object creation, after setting all properties.
function lbNormalizer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbNormalizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lbGrouping.
function lbGrouping_Callback(hObject, eventdata, handles)
% hObject    handle to lbGrouping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbGrouping contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbGrouping


% --- Executes during object creation, after setting all properties.
function lbGrouping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbGrouping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lbSeries.
function lbSeries_Callback(hObject, eventdata, handles)
% hObject    handle to lbSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbSeries contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbSeries


% --- Executes during object creation, after setting all properties.
function lbSeries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iNormalizer = get(handles.lbNormalizer, 'value');
if length(handles.iNormalizer) > 1 & any(handles.iNormalizer == 1)
    errordlg('Multiple selection includes ''#NONE''! Please change normalizer selection.', 'Invalid Normalizer');
    return
elseif handles.iNormalizer == 1
    % return empty if '#NONE' is selected
    handles.iNormalizer = [];
end

handles.iSubstrates = get(handles.lbSubstrate, 'value');
handles.iGrouping = get(handles.lbGrouping, 'value');
handles.iSeries = get(handles.lbSeries, 'value');
guidata(hObject, handles);
set(gcf, 'Visible', 'off');


 
