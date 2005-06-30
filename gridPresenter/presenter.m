function varargout = presenter(varargin)
% PRESENTER M-file for presenter.fig
%      PRESENTER, by itself, creates a new PRESENTER or raises the existing
%      singleton*.
%
%      H = PRESENTER returns the handle to a new PRESENTER or the handle to
%      the existing singleton*.
%
%      PRESENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRESENTER.M with the given input arguments.
%
%      PRESENTER('Property','Value',...) creates a new PRESENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before presenter_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to presenter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help presenter

% Last Modified by GUIDE v2.5 30-May-2005 16:35:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @presenter_OpeningFcn, ...
                   'gui_OutputFcn',  @presenter_OutputFcn, ...
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


% --- Executes just before presenter is made visible.
function presenter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to presenter (see VARARGIN)

% Choose default command line output for presenter
handles.output = hObject;
handles.I = varargin{1};
handles.oQ = varargin{2};

if length(varargin) == 3
    handles.xSeries = varargin{3};
else
    handles.xSeries = 1:size(handles.I,3);
end





% show images
focus = [1,1];
xFocus = size(handles.I,3);
[handles.hImage, handles.hSpots] = showImage(handles.axImage, handles.oQ(:,:,xFocus), handles.I(:,:,xFocus));
hAx = [handles.axImage, handles.axSegSpot, handles.axTrueSpot, handles.axQuantification];
handles.hFocusPlot = focalSpot(hAx, handles.I(:,:,xFocus), handles.hSpots(focus(1), focus(2)), handles.oQ(focus(1),focus(2),:), handles.hSpots(end, end), handles.oQ(end, end,:), xFocus, handles.xSeries);

handles.focus       = focus;
handles.xFocus      = xFocus;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes presenter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = presenter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cbSig.
function cbSig_Callback(hObject, eventdata, handles)
% hObject    handle to cbSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSig


% --- Executes on button press in cbBg.
function cbBg_Callback(hObject, eventdata, handles)
% hObject    handle to cbBg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbBg


% --- Executes on button press in cbSigmBg.
function cbSigmBg_Callback(hObject, eventdata, handles)
% hObject    handle to cbSigmBg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbSigmBg

function image_Callback(hObject, eventData, handles)
point = get(handles.axImage, 'CurrentPoint');
yPoint = point(1,1) * ones(size(handles.x));
xPoint = point(1,2) * ones(size(handles.y));
dx = handles.x-xPoint;
dy = handles.y-yPoint;
L = (dx.^2 + dy.^2);

[minL, iFocus, jFocus] = minn(L);
iOld = handles.focus(1);
jOld = handles.focus(2);
hAx = [handles.axImage, handles.axSegSpot, handles.axTrueSpot, handles.axQuantification];
handles.hFocusPlot = focalSpot(hAx, handles.I(:,:,handles.xFocus) , handles.hSpots(iFocus, jFocus), handles.oQ(iFocus, jFocus, :), handles.hSpots(iOld, jOld), handles.oQ(iOld, jOld), handles.xFocus, handles.xSeries);
handles.focus = [iFocus, jFocus];

guidata(hObject, handles);

function spot_Callback(hObject, eventData, handles);
iOld = handles.focus(1);
jOld = handles.focus(2);

qOld = handles.oQ(iOld, jOld,:);
hOldFocus = handles.hSpots(iOld, jOld);
[iNew, jNew] = find(handles.hSpots == hObject);
qNew = handles.oQ(iNew, jNew,:);

hAx = [handles.axImage, handles.axSegSpot, handles.axTrueSpot, handles.axQuantification];
handles.hFocusPlot = focalSpot(hAx, handles.I(:,:,handles.xFocus), hObject, qNew, hOldFocus, qOld, handles.xFocus, handles.xSeries);
handles.focus = [iNew, jNew];
guidata(hObject, handles);

function plot_Callback(hObject, eventData, handles)
delete(handles.hFocusPlot);
xPoint = get(handles.axQuantification,'CurrentPoint');
xPoint = xPoint(1,1) * ones(size(handles.xSeries));
[mdx,handles.xFocus] = min(abs(xPoint - handles.xSeries));
[handles.hImage, handles.hSpots] = showImage(handles.axImage, handles.oQ(:,:,handles.xFocus), handles.I(:,:,handles.xFocus));
hAx = [handles.axImage, handles.axSegSpot, handles.axTrueSpot, handles.axQuantification];
focus = handles.focus;
handles.hFocusPlot = focalSpot(hAx, handles.I(:,:,handles.xFocus), handles.hSpots(focus(1), focus(2)), handles.oQ(focus(1),focus(2),:), handles.hSpots(end, end), handles.oQ(end, end,:), handles.xFocus, handles.xSeries);
guidata(handles.axQuantification, handles);

function [hImage, hSpots] = showImage(hAxis, oQ, I,focus, dr);

if nargin < 4
    dr = [];
end
axes(hAxis);
[hImage, hSpots] =show(oQ, I,dr);

%set(hImage, 'ButtonDownFcn', 'presenter(''image_Callback'',gcbo,[],guidata(gcbo))');
set(hSpots, 'ButtonDownFcn', 'presenter(''spot_Callback'',gcbo,[],guidata(gcbo))');

function hFocusPlot = focalSpot(hAx, I, hNewFocus, qNew, hOldFocus, qOld, xFocus, xSeries);

axes(hAx(1));
if get(qOld(xFocus), 'isSpot');
    set(hOldFocus,'color', 'w', 'linewidth', 0.5);
else
    set(hOldFocus, 'color', 'k', 'linewidth', 0.5);
end

set(hNewFocus, 'color', 'm', 'linewidth', 2);

axes(hAx(2))
bin = get(qNew(xFocus), 'binSpot');
ignored = get(qNew(xFocus), 'ignoredPixels');
segview = double(bin);

[iIgnored, jIgnored] = find(ignored == 1);
segview(iIgnored, jIgnored) = 0.5;

imshow(segview);
colormap(gca, 'jet');

axes(hAx(3))
cLu = get(qNew(xFocus), 'cLu');
x = cLu(1):cLu(1) + size(bin,1) - 1;
y = cLu(2):cLu(2) + size(bin,2) - 2;
imshow(I(x,y));
colormap(gca, 'jet');
hold on
B = bwboundaries(bin);
bound = cell2mat(B);

isSpot = get(qNew(xFocus), 'isSpot');
if isSpot
        plot(bound(:,2) , bound(:,1), 'w');
else
        plot(bound(:,2) , bound(:,1), 'k');
end
axes(hAx(4));
hold off

nImages = length(qNew);
if nImages > 1
    %image series
  
    for i=1:nImages
        s(i) = get(qNew(i), 'medianSignal');
        b(i) = get(qNew(i), 'medianBackground');
    end
    n = s-b;
    hold off
    h(1) = plot(xSeries, s, 'ro-');
    hold on
    h(2) = plot(xSeries, b, 'bo-');
    h(3) = plot(xSeries, n, 'go-');
    hFocusPlot = plot(xSeries(xFocus), [s(xFocus),b(xFocus),n(xFocus)], 'mdiamond');
    set(hFocusPlot, 'markerfacecolor', 'm');
    set(h, 'ButtonDownFcn', 'presenter(''plot_Callback'',gcbo,[],guidata(gcbo))');
    set(h, 'MarkerSize', 6);
else
    s = get(qNew, 'medianSignal');
    b = get(qNew, 'medianBackground');
    n = s-b;
    h = bar(1,s);
    hFocusPlot = h;
    set(h, 'facecolor', 'r');
    hold on
    h = bar(2,b);
    set(h, 'facecolor', 'b');
    h = bar(3,n);
    set(h, 'facecolor', 'g');

    set(gca, 'xticklabel', []);
end
id = get(qNew(1), 'ID');
title(id, 'interpreter', 'none', 'fontsize', 8);

