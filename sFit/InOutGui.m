function varargout = InOutGui(varargin)
% INOUTGUI M-file for InOutGui.fig
%      INOUTGUI, by itself, creates a new INOUTGUI or raises the existing
%      singleton*.
%
%      H = INOUTGUI returns the handle to a new INOUTGUI or the handle to
%      the existing singleton*.
%
%      INOUTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INOUTGUI.M with the given input arguments.
%
%      INOUTGUI('Property','Value',...) creates a new INOUTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InOutGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InOutGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InOutGui

% Last Modified by GUIDE v2.5 22-Jun-2005 11:20:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InOutGui_OpeningFcn, ...
                   'gui_OutputFcn',  @InOutGui_OutputFcn, ...
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


% --- Executes just before InOutGui is made visible.
function InOutGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InOutGui (see VARARGIN)

% Choose default command line output for InOutGui
x = varargin{1};
y = varargin{2};
xFit = varargin{3};
yFit = varargin{4};
handles.out = varargin{5};

axes(handles.axPlot);
hold off
handles.hPlot = [];

for i=1:length(x)
    
    handles.hPlot(i) = plot(x(i), y(i),'ko');
    hold on
end
plot(xFit, yFit);
set(handles.hPlot, 'markersize', 10);
set(handles.hPlot, 'ButtonDownFcn', 'InOutGui(''toggle'',gcbo, [], guidata(gcbo))');
if any(handles.out)
    out = logical(handles.out);
    set(handles.hPlot(out), 'marker', 'x', 'color', 'r', 'markersize', 20); 
end
v = axis;
axis([min(x)-1, max(x) + 1, v(3), v(4)]); 
%InOutGui('pushbutton1_Callback',gcbo,[],guidata(gcbo))
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InOutGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InOutGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(gcf);
function toggle(hObject, eventData, handles)
iObject = find(hObject == handles.hPlot);
if handles.out(iObject)
    set(hObject, 'marker', 'o', 'color', 'k', 'markersize', 10);
    handles.out(iObject) = 0;
else
   set(hObject, 'marker', 'x', 'color', 'r', 'markersize', 20);
   handles.out(iObject) = 1;
end
guidata(hObject, handles);