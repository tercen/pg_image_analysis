function varargout = II_export(varargin)
% II_export M-file for II_export.fig
%      II_export, by itself, creates a new II_export or raises the existing
%      singleton*.
%
%      H = II_export returns the handle to a new II_export or the handle to
%      the existing singleton*.
%
%      II_export('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in II_export.M with the given input arguments.
%
%      II_export('Property','Value',...) creates a new II_export or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before II_export_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to II_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help II_export

% Last Modified by GUIDE v2.5 07-May-2003 15:47:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @II_export_OpeningFcn, ...
                   'gui_OutputFcn',  @II_export_OutputFcn, ...
                   'gui_LayoutFcn',  @II_export_LayoutFcn, ...
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


% --- Executes just before II_export is made visible.
function II_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to II_export (see VARARGIN)

% Choose default command line output for II_export
handles.output = hObject;
set(findobj('Tag', 'rbFD10'),   'Value', 1);
set(findobj('Tag', 'rbPS4' ),   'Value', 0);
set(findobj('Tag', 'rbPS96'),   'Value', 0);
set(findobj('Tag', 'pbMakeKinetics'), 'Enable', 'off');
set(findobj('Tag', 'pbMakeList')    , 'Enable', 'off');
set(findobj('Tag', 'pbMakeV')       , 'Enable', 'off');
% Default ini pars
handles.iniFile = 'II.ini';
handles.IniPars.initialDir = 'G:\users\kinase';
handles.IniPars = getparsfromfile(handles.iniFile, handles.IniPars);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes II_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function II_export_Close(hObject, handles)
% function called on closing
%putparstofile(handles.iniFile, handles.IniPars);


closereq;

% --- Outputs from this function are returned to the command line.
function varargout = II_export_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbGetData.
function pbGetData_Callback(hObject, eventdata, handles)
% hObject    handle to pbGetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder = uigetfolder('Select folder with data ...', handles.IniPars.initialDir);
if isempty(folder), return, end;

set(hObject, 'Enable', 'off');
set(findobj('Tag', 'stStatus'), 'String', 'Searching for data ... please wait');
drawnow;

% now search for .tif files with an associated .txt file
FileListTif = filehound(folder, '*.tif');
FileListTxt = filehound(folder, '*.txt');
if length(FileListTif) == 0 | length(FileListTxt) == 0
    errordlg(['No data found in: ', folder], 'II');
    set(hObject, 'Enable', 'on');
    set(findobj('Tag', 'stStatus'), 'String', 'ready');
    return
end
% create a cell array with the filenames from FileListTxt
[clTxtNames{1:length(FileListTxt)}] = deal(FileListTxt.fPath);
% search for matching names and put in FileListMatch
nMatch = 0;
FileListMatch = struct('fPath', '', 'isLast', 0);
for i=1:length(FileListTif)
    iMatch = strmatch(fnReplaceExtension(FileListTif(i).fPath, 'txt'), clTxtNames);
    if (~isempty(iMatch))
        nMatch = nMatch+1;
        FileListMatch(nMatch) = FileListTxt(iMatch);  
    end
end
if nMatch > 0
    set(findobj('Tag', 'stStatus'), 'String', [num2str(nMatch), ' files found in: ', folder]);
    set(findobj('Tag', 'pbMakeKinetics')    , 'Enable', 'on');
    set(findobj('Tag', 'pbMakeList')        , 'Enable', 'off');
    set(findobj('Tag', 'pbMakeV')           , 'Enable', 'off');
else
    FileListMatch = struct([]);
    errordlg(['No data found in: ', folder], 'II');
    set(findobj('Tag', 'stStatus'), 'String', 'ready');    
    set(findobj('Tag', 'pbMakeKinetics')    , 'Enable', 'off');
    set(findobj('Tag', 'pbMakeList')        , 'Enable', 'off');
    set(findobj('Tag', 'pbMakeV')           , 'Enable', 'off');
end

set(hObject, 'Enable', 'on');
handles.IniPars.initialDir = folder;
handles.FileList = FileListMatch;
guidata(hObject, handles);


% --- Executes on button press in cbMean.
function cbMean_Callback(hObject, eventdata, handles)
% hObject    handle to cbMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbMean


% --- Executes on button press in cbMedian.
function cbMedian_Callback(hObject, eventdata, handles)
% hObject    handle to cbMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbMedian


% --- Executes on button press in cbMode.
function cbMode_Callback(hObject, eventdata, handles)
% hObject    handle to cbMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbMode


% --- Executes on button press in rbPS96.
function rbPS96_Callback(hObject, eventdata, handles)
% hObject    handle to rbPS96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPS96

set(hObject, 'Value', 1);
set(findobj('Tag','rbPS4'), 'Value', 0);
set(findobj('Tag','rbFD10'), 'Value', 0);

% --- Executes on button press in rbPS4.
function rbPS4_Callback(hObject, eventdata, handles)
% hObject    handle to rbPS4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbPS4

set(hObject, 'Value', 1);
set(findobj('Tag','rbPS96'), 'Value', 0);
set(findobj('Tag','rbFD10'), 'Value', 0);
% --- Executes on button press in rbFD10.
function rbFD10_Callback(hObject, eventdata, handles)
% hObject    handle to rbFD10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbFD10
set(hObject, 'Value', 1);
set(findobj('Tag','rbPS96'), 'Value', 0);
set(findobj('Tag','rbPS4' ), 'Value', 0);

% --- Executes on button press in pbMakeKinetics.
function pbMakeKinetics_Callback(hObject, eventdata, handles)
% hObject    handle to pbMakeKinetics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable' , 'off')
resDir = '_Quantified Results';
mkdir(handles.IniPars.initialDir, resDir);
SaveDir = [handles.IniPars.initialDir, '\', resDir];

set(findobj('Tag', 'stStatus'), 'String', 'Integrating into kinetic series, please wait ...');

OutputOptions.mean      = get(findobj('Tag', 'cbMean'), 'Value');
OutputOptions.median    = get(findobj('Tag', 'cbMedian'),'Value');
OutputOptions.mode      = get(findobj('Tag', 'cbMode'), 'Value');
OutputOptions.format    = 'kinetics';

if (get(findobj('Tag', 'rbFD10'), 'Value'))
    OutputOptions.sInstrument = 'FD10';
elseif (get(findobj('Tag', 'rbPS96'), 'Value'))
    OutputOptions.sInstrument = 'PS96';
elseif(get(findobj('Tag', 'rbPS4'), 'Value'))
    OutputOptions.sInstrument = 'PS4';
end


IIntegrate(SaveDir, handles.FileList, OutputOptions);


guidata(hObject, handles);
set(hObject, 'Enable', 'on');
set(findobj('Tag', 'stStatus'), 'String', 'done ...');
% --- Executes on button press in pbMakeList.
function pbMakeList_Callback(hObject, eventdata, handles)
% hObject    handle to pbMakeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Enable', 'off')


% --- Executes on button press in pbMakeV.
function pbMakeV_Callback(hObject, eventdata, handles)
% hObject    handle to pbMakeV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Enable', 'off')


function IIntegrate(SaveDir, FileList, OutputOptions)

nFiles = length(FileList)
bNextDir = 1;
i = 0;

 meanSig = []; meanBg = [];
 medianSig = []; medianBg = [];
 modeSig = []; modeBg = [];

for n=1:nFiles
    if(bNextDir)
        % for a new directory the result files are scanned for IDs
        % of Median. Mode, Mean, row, col, Gene ID
        bNextDir = 0; 
        [cHeaders, nSpots] = imgScanFile(FileList(n).fPath);
        nCols = length(cHeaders);
        iMeanSig =strmatch('Signal Mean', cHeaders, 'exact');
        iMeanBg =strmatch('Background Mean',cHeaders,'exact');
        iMedianSig =strmatch('Signal Median', cHeaders, 'exact');
        iMedianBg =strmatch('Background Median',cHeaders,'exact');
        iModeSig =strmatch('Signal Mode', cHeaders, 'exact');
        iModeBg =strmatch('Background Mode',cHeaders,'exact');
        iGeneID     = strmatch('Gene ID', cHeaders, 'exact');
        iRow        = strmatch('Row',cHeaders,'exact');
        iCol        = strmatch('Column',cHeaders,'exact');
    end   
    [cData, rFlag] = imgReadFile(FileList(n).fPath, nSpots, nCols);
    
    if (rFlag ~= -1)
        i = i+1;
        C(i) = fname2cycle(FileList(n).fPath, OutputOptions.sInstrument);
        for j=1:nSpots
            if (OutputOptions.mean) & ~isempty(iMeanSig) & ~isempty(iMeanBg)
                meanSig(i,j) = str2num(char(cData(j, iMeanSig)));
                meanBg(i,j) = str2num(char(cData(j, iMeanBg)));
            end
            if  (OutputOptions.median) & ~isempty(iMedianSig) & ~isempty(iMedianBg)
                medianSig(i,j) = str2num(char(cData(j, iMedianSig)));
                medianBg(i,j) = str2num(char(cData(j, iMedianBg)));
            end
            if  (OutputOptions.mode) & ~isempty(iModeSig) & ~isempty(iModeBg)
                modeSig(i,j) = str2num(char(cData(j, iModeSig)));
                modeBg(i,j) = str2num(char(cData(j, iModeBg)));
            end
            
            GeneID(j) = cData(j, iGeneID); 
            row(j)    = str2num(char(cData(j, iRow)));
            col(j)    = str2num(char(cData(j, iCol)));     
        end
           
        
        
        
    end    
     rBase = fname2rbase(FileList(n).fPath, OutputOptions.sInstrument);
    if(FileList(n).isLast)
        if ~isempty(modeSig)
            modeSigmBg = modeSig - modeBg;        
            SaveData([SaveDir, '\', rBase,'_ModeSig.dat'], OutputOptions.format,  C', modeSig, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_ModeBg.dat'] , OutputOptions.format,   C', modeBg, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_ModeSigmBg.dat'], OutputOptions.format,C', modeSigmBg, GeneID, row, col);
        end
        if ~isempty(medianSig)
            medianSigmBg = medianSig - medianBg;
            SaveData([SaveDir, '\', rBase,'_MedianSig.dat'], OutputOptions.format,  C', medianSig, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_MedianBg.dat'] , OutputOptions.format,   C', medianBg, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_MedianSigmBg.dat'], OutputOptions.format,C', medianSigmBg, GeneID, row, col);    
            
        end
        if ~isempty(meanSig)
            meanSigmBg = meanSig - meanBg;
            SaveData([SaveDir, '\', rBase,'_MeanSig.dat'], OutputOptions.format,  C', meanSig, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_MeanBg.dat'] , OutputOptions.format,   C', meanBg, GeneID, row, col);
            SaveData([SaveDir, '\', rBase,'_MeanSigmBg.dat'], OutputOptions.format,C', meanSigmBg, GeneID, row, col);    
            
        end
       
        
        bNextDir = 1; 
        i = 0;
    end
    
end  

function SaveData(fileName, saveFormat,x, y, geneID, row, col)

switch saveFormat
    case 'kinetics'
        WriteKinetics(fileName, x, y, geneID, row, col);
end



% --- Creates and returns a handle to the GUI figure. 
function h1 = II_export_LayoutFcn(policy)
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
'Name','I.I.',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[103.8 42.3076923076923 74.8 19.1538461538462],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', [], ...
'taginfo', struct(...
'figure', 2, ...
'pushbutton', 5, ...
'frame', 7, ...
'checkbox', 5, ...
'text', 5, ...
'radiobutton', 3), ...
'override', 0, ...
'release', 13, ...
'resize', 'none', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'blocking', 0, ...
'lastSavedFile', 'G:\dataanalysis\matlab\II\II.m'));


h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'ListboxTop',0,...
'Position',[-0.2 -0.153846153846154 75.6 2.92307692307692],...
'String',{ '' },...
'Style','frame',...
'Tag','frame6');


h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','II_export(''pbGetData_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[4.6 12.9230769230769 15.4 2.38461538461538],...
'String','Get Data',...
'Tag','pbGetData');


h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'ListboxTop',0,...
'Position',[29.8 7.76923076923077 20.2 8.84615384615385],...
'String',{ '' },...
'Style','frame',...
'Value',1,...
'Tag','frame4');


h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'ListboxTop',0,...
'Position',[53.4 7.76923076923077 19.4 8.84615384615385],...
'String',{ '' },...
'Style','frame',...
'Tag','frame5');


h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''cbMean_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[33.6 12.3846153846154 13.2 1.15384615384615],...
'String','Mean',...
'Style','checkbox',...
'Value',1,...
'Tag','cbMean');


h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''cbMedian_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[33.6 10.6923076923077 13.2 1.15384615384615],...
'String','Median',...
'Style','checkbox',...
'Value',1,...
'Tag','cbMedian');


h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''cbMode_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[33.6 8.76923076923077 13.2 1.15384615384615],...
'String','Mode',...
'Style','checkbox',...
'Value',1,...
'Tag','cbMode');


h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'ListboxTop',0,...
'Position',[32.4 13.4615384615385 14.2 1.84615384615385],...
'String','Measurements',...
'Style','text',...
'Tag','text1');


h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'ListboxTop',0,...
'Position',[55.8 13.4615384615385 14.2 1.84615384615385],...
'String','Instrument',...
'Style','text',...
'Tag','text2');


h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''rbPS96_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[56.8 12.3846153846154 13.2 1.15384615384615],...
'String','PS96',...
'Style','radiobutton',...
'Tag','rbPS96');


h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''rbPS4_Callback'',gcbo,[],guidata(gcbo))',...
'Enable','off',...
'ListboxTop',0,...
'Position',[56.8 10.4615384615385 13.2 1.15384615384615],...
'String','PS4',...
'Style','radiobutton',...
'Tag','rbPS4');


h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'Callback','II_export(''rbFD10_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[56.8 8.53846153846154 13.2 1.15384615384615],...
'String','FD10',...
'Style','radiobutton',...
'Tag','rbFD10');


h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','II_export(''pbMakeKinetics_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[57.4 3.69230769230769 15.4 2.38461538461538],...
'String','Make Kinetics',...
'Tag','pbMakeKinetics');


h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.909803921568627 0.996078431372549 1],...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[2.4 -0.230769230769231 67.6 2.61538461538462],...
'String','Ready',...
'Style','text',...
'Tag','stStatus');


h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','II_export(''pbMakeList_Callback'',gcbo,[],guidata(gcbo))',...
'Enable','off',...
'ListboxTop',0,...
'Position',[39.8 3.69230769230769 15.4 2.38461538461538],...
'String','Make List',...
'Tag','pbMakeList');


h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','II_export(''pbMakeV_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[21.8 3.61538461538462 15.4 2.38461538461538],...
'String','Make v-file',...
'Tag','pbMakeV');



hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      II_EXPORT, by itself, creates a new II_EXPORT or raises the existing
%      singleton*.
%
%      H = II_EXPORT returns the handle to a new II_EXPORT or the handle to
%      the existing singleton*.
%
%      II_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in II_EXPORT.M with the given input arguments.
%
%      II_EXPORT('Property','Value',...) creates a new II_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2004/09/20 11:56:07 $

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
    % II_EXPORT
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % II_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % II_EXPORT(...)
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
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

