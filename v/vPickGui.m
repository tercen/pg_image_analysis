function varargout = vPickList(varargin)
% VPICKLIST M-file for vPickList.fig
%      VPICKLIST, by itself, creates a new VPICKLIST or raises the existing
%      singleton*.
%
%      H = VPICKLIST returns the handle to a new VPICKLIST or the handle to
%      the existing singleton*.
%
%      VPICKLIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VPICKLIST.M with the given input arguments.
%
%      VPICKLIST('Property','Value',...) creates a new VPICKLIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vPickList_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vPickList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vPickList

% Last Modified by GUIDE v2.5 23-Mar-2004 12:56:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vPickList_OpeningFcn, ...
                   'gui_OutputFcn',  @vPickList_OutputFcn, ...
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


% --- Executes just before vPickList is made visible.
function vPickList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vPickList (see VARARGIN)

% Choose default command line output for vPickList
handles.output = hObject;

strCol = varargin{2};
v = varargin{1};
fldNames = fieldnames(v);


iMatch = strmatch(strCol, fldNames,'exact');

clList = cell(1,1);
clList(1) = cellstr('');
if (~isempty(iMatch))
    if ~isstr(v(1).(strCol))
        error('vPickList only handles string fields');
    end
    
    j =0 ;
    for i=1:length(v)
        hlp = v(i).(strCol);
        iM = strmatch(hlp, clList);
        if (isempty(iM))
            j = j + 1;
            clList(j) = cellstr(hlp);
        end
    end
end
clList = cellstr(sortrows(char(clList)));
set(findobj('Tag','lbList'), 'String', clList);


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes vPickList wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vPickList_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function lbList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lbList.
function lbList_Callback(hObject, eventdata, handles)
% hObject    handle to lbList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbList


% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hLb = findobj('Tag', 'lbList');
    strList = get(hLb, 'String');
    handles.strList = strList(get(hLb, 'value'));
    set(gcf, 'Visible', 'off');
    guidata(hObject, handles);
