function varargout = resPlot(varargin)
% RESPLOT M-file for resPlot.fig
%      RESPLOT, by itself, creates a new RESPLOT or raises the existing
%      singleton*.
%
%      H = RESPLOT returns the handle to a new RESPLOT or the handle to
%      the existing singleton*.
%
%      RESPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPLOT.M with the given input arguments.
%
%      RESPLOT('Property','Value',...) creates a new RESPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resPlot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help resPlot

% Last Modified by GUIDE v2.5 25-Mar-2002 12:19:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @resPlot_OutputFcn, ...
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


% --- Executes just before resPlot is made visible.
function resPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resPlot (see VARARGIN)

% Choose default command line output for resPlot
handles.output = hObject;
handles.absRes = varargin{1};
handles.relRes = varargin{2};


axes(findobj('Tag', 'axAbsRes'));
sar = size(handles.absRes);
if sar(2) >= 2
    plot(handles.absRes(:,1), handles.absRes(:,2:sar(2)),'.-')
    title('Absolute Residuals');
end

axes(findobj('Tag', 'axRelRes'));
srr = size(handles.relRes);
if srr(2) >= 2
    plot(handles.relRes(:,1), handles.relRes(:,2:srr(2)),'.-')
    title('Relative Residuals');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
