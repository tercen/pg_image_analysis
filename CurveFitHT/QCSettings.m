function varargout = QCSettings(varargin)
% QCSETTINGS M-file for QCSettings.fig
%      QCSETTINGS, by itself, creates a new QCSETTINGS or raises the existing
%      singleton*.
%
%      H = QCSETTINGS returns the handle to a new QCSETTINGS or the handle to
%      the existing singleton*.
%
%      QCSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QCSETTINGS.M with the given input arguments.
%
%      QCSETTINGS('Property','Value',...) creates a new QCSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QCSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QCSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QCSettings

% Last Modified by GUIDE v2.5 12-May-2004 13:38:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QCSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @QCSettings_OutputFcn, ...
                   'gui_LayoutFcn',  @QCSettings_LayoutFcn, ...
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


% --- Executes just before QCSettings is made visible.
function QCSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QCSettings (see VARARGIN)

% Choose default command line output for QCSettings
handles.output = hObject;
varargin
handles.minimalR2           = varargin{1};
handles.minimalEndLevel     = varargin{2};
handles.minimalVini         = varargin{3};

handles.minimalR2;

set(findobj('Tag','edMinimalR2'), 'String', num2str(handles.minimalR2));
set(findobj('Tag','edMinimalEndLevel'),'String',num2str(handles.minimalEndLevel));
set(findobj('Tag','edMinimalVini'),'String',num2str(handles.minimalVini));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QCSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QCSettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in pbOK.
function pbOK_Callback(hObject, eventdata, handles)
% hObject    handle to pbOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.bPressed = 'OK';
guidata(hObject, handles);
set(gcf, 'Visible', 'off');

% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.bPressed = 'Cancel';
guidata(hObject, handles);
set(gcf, 'Visible', 'off');


% --- Executes during object creation, after setting all properties.
function edMinimalVini_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMinimalEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edMinimalVini_Callback(hObject, eventdata, handles)
% hObject    handle to edMinimalEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edMinimalEndLevel as text
%        str2double(get(hObject,'String')) returns contents of edMinimalEndLevel as a double

val = str2num(get(hObject,'String'));
if ~isempty(val)
    handles.minimalVini = val;
else
    set(hObject, 'String', num2str(handles.minimalVini));
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edMinimalEndLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMinimalEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edMinimalEndLevel_Callback(hObject, eventdata, handles)
% hObject    handle to edMinimalEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edMinimalEndLevel as text
%        str2double(get(hObject,'String')) returns contents of edMinimalEndLevel as a double
val = str2num(get(hObject,'String'));
if ~isempty(val)
    handles.minimalEndLevel = val;
else
    set(hObject, 'String', num2str(handles.minimalEndLevel));
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function edMinimalR2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMinimalR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edMinimalR2_Callback(hObject, eventdata, handles)
% hObject    handle to edMinimalR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edMinimalR2 as text
%        str2double(get(hObject,'String')) returns contents of edMinimalR2 as a double

val = str2num(get(hObject,'String'));
if ~isempty(val)
    handles.minimalR2 = val;
else
    set(hObject, 'String', num2str(handles.minimalR2));
end
guidata(hObject, handles);


% --- Creates and returns a handle to the GUI figure. 
function h1 = QCSettings_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

h1 = figure(...
'Units','characters',...
'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','QCSettings',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[103.8 15.5384615384615 65 45.9230769230769],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1',...
'UserData',[]);

setappdata(h1, 'GUIDEOptions',struct(...
'active_h', [21.0013427734375;111.000244140625], ...
'taginfo', struct(...
'figure', 2, ...
'edit', 6, ...
'frame', 2, ...
'pushbutton', 7, ...
'text', 5), ...
'override', 0, ...
'release', 13, ...
'resize', 'none', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'blocking', 0, ...
'lastSavedFile', 'G:\dataanalysis\matlab\CurveFitHTv11\QCSettings.m'));


h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 1 0.996078431372549],...
'ListboxTop',0,...
'Position',[4.2 5.84615384615385 55.8 39.2307692307692],...
'String',{  '' },...
'Style','frame',...
'Tag','frame1');





h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','QCSettings(''pbOK_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[46.8 1.38461538461538 13.2 2.15384615384615],...
'String','OK',...
'Tag','pbOK');


h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','QCSettings(''pbCancel_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[26.8 1.38461538461538 13.2 2.15384615384615],...
'String','Cancel',...
'Tag','pbCancel');


h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.996078431372549 1],...
'FontSize',10,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[13 38.0769230769231 22.2 1.92307692307692],...
'String','Minimal R^2',...
'Style','text',...
'Tag','text1');


h7m = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','QCSettings(''edMinimalEndLevel_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[35.4 34.3846153846154 14.6 2.53846153846154],...
'String','',...
'Style','edit',...
'CreateFcn','QCSettings(''edMinimalEndLevel_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edMinimalEndLevel');



h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','QCSettings(''edMinimalVini_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[35.4 30.7 14.6 2.53846153846154],...
'String','',...
'Style','edit',...
'CreateFcn','QCSettings(''edMinimalVini_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edMinimalVini');


h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','QCSettings(''edMinimalR2_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[35.4 38.0769230769231 14.6 2.53846153846154],...
'String','',...
'Style','edit',...
'CreateFcn','QCSettings(''edMinimalR2_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','edMinimalR2');


h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.996078431372549 1],...
'FontSize',10,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[13 34.6923076923077 22.2 1.92307692307692],...
'String','Minimal End Level',...
'Style','text',...
'Tag','text2');


h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.996078431372549 1],...
'FontSize',10,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[13 30.6923076923077 22.2 1.92307692307692],...
'String','Minimal Vini',...
'Style','text',...
'Tag','text3');


h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.996078431372549 1],...
'FontSize',10,...
'FontWeight','demi',...
'ListboxTop',0,...
'Position',[9.8 41.9230769230769 38 1.30769230769231],...
'String','Enter criteria for QC flagging',...
'Style','text',...
'Tag','text4');



hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      QCSETTINGS, by itself, creates a new QCSETTINGS or raises the existing
%      singleton*.
%
%      H = QCSETTINGS returns the handle to a new QCSETTINGS or the handle to
%      the existing singleton*.
%
%      QCSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QCSETTINGS.M with the given input arguments.
%
%      QCSETTINGS('Property','Value',...) creates a new QCSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2004/07/20 19:43:58 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % QCSETTINGS
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % QCSETTINGS('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % QCSETTINGS(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
try
    gui_hFigure = openfig(name, singleton, 'auto');
catch
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

