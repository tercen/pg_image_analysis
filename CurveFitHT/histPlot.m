function varargout = histPlot(varargin)
% HISTPLOT M-file for histPlot.fig
%      HISTPLOT, by itself, creates a new HISTPLOT or raises the existing
%      singleton*.
%
%      H = HISTPLOT returns the handle to a new HISTPLOT or the handle to
%      the existing singleton*.
%
%      HISTPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTPLOT.M with the given input arguments.
%
%      HISTPLOT('Property','Value',...) creates a new HISTPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before histPlot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to histPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help histPlot

% Last Modified by GUIDE v2.5 28-Jun-2004 13:52:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @histPlot_OutputFcn, ...
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


% --- Executes just before histPlot is made visible.
function histPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to histPlot (see VARARGIN)

% Choose default command line output for histPlot
handles.output = hObject;
absRes = varargin{1};
relRes = varargin{2};
nBins  = varargin{3};


sRes = size(absRes);
absRes = reshape(absRes, sRes(1)*sRes(2), 1);
relRes = reshape(relRes, sRes(1)*sRes(2), 1);
mAbsRes = mean(absRes);
sAbsRes = std(absRes);
mRelRes = mean(relRes);
sRelRes = std(relRes);


axes(findobj('Tag', 'axAbsRes'));
hist(absRes, nBins);
title(['absolute residuals: av:',num2str(mAbsRes, 2), ' std: ',num2str(sAbsRes, 3)]);
axes(findobj('Tag', 'axRelRes'));
hist(relRes, nBins);
title(['absolute residuals: av:',num2str(mRelRes, 2), ' std: ',num2str(sRelRes, 3)]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes histPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = histPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
