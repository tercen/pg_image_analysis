function varargout = II(varargin)
% II M-file for II.fig
%      II, by itself, creates a new II or raises the existing
%      singleton*.
%
%      H = II returns the handle to a new II or the handle to
%      the existing singleton*.
%
%      II('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in II.M with the given input arguments.
%
%      II('Property','Value',...) creates a new II or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before II_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to II_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help II

% Last Modified by GUIDE v2.5 18-Jun-2004 11:51:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @II_OpeningFcn, ...
                   'gui_OutputFcn',  @II_OutputFcn, ...
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


% --- Executes just before II is made visible.
function II_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to II (see VARARGIN)

% Choose default command line output for II
handles.output = hObject;
handles.cOn = [0, 0.3, 0.8];
handles.cOff = [0.8, 0.8, 0.8];
set(findobj('Tag', 'rbFD10'),   'Value', 1, 'Enable', 'on');
set(findobj('Tag', 'rbPS4' ),   'Value', 0, 'Enable', 'on');
set(findobj('Tag', 'rbPS96'),   'Value', 0, 'Enable', 'on');
set(findobj('Tag', 'pbMakeKinetics'), 'Enable', 'off');
set(findobj('Tag', 'pbMakeList')    , 'Enable', 'off');
set(findobj('Tag', 'pbMakeV')       , 'Enable', 'off');
set(findobj('Tag', 'frIndicator'), 'BackgroundColor', handles.cOff);
% Default ini pars
handles.iniFile = 'II.ini';
handles.IniPars.initialDir = 'G:\users\kinase';
handles.IniPars = getparsfromfile(handles.iniFile, handles.IniPars);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes II wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function II_Close(hObject, eventdata, handles)
% function called on closing
%putparstofile(handles.iniFile, handles.IniPars);

SetIniPars(handles.iniFile, handles.IniPars);
closereq;

% --- Outputs from this function are returned to the command line.
function varargout = II_OutputFcn(hObject, eventdata, handles)
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

folder = uigetdir(handles.IniPars.initialDir,'Select folder with data ...' );
if folder == 0, return, end;

set(hObject, 'Enable', 'off');
set(findobj('Tag', 'stStatus'), 'String', 'Searching for data ... please wait');
drawnow;

% now search for .tif files with an associated .txt file
set(findobj('Tag','frIndicator'), 'BackgroundColor', handles.cOn);
drawnow;
FileListTif = filehound(folder, '*.tif');
set(findobj('Tag','frIndicator'), 'BackgroundColor', handles.cOff);
drawnow;
FileListTxt = filehound(folder, '*.txt');
set(findobj('Tag', 'frIndicator'), 'BackgroundColor', handles.cOn);
drawnow;
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
    set(findobj('Tag', 'pbMakeList')        , 'Enable', 'on');
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
set(findobj('Tag','frIndicator'), 'BackgroundColor', handles.cOff);
drawnow;
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


IIntegrate(SaveDir, handles.FileList, OutputOptions, handles.cOn, handles.cOff);


guidata(hObject, handles);
set(hObject, 'Enable', 'on');
nMatch = length(handles.FileList);
folder = handles.IniPars.initialDir;
set(findobj('Tag', 'stStatus'), 'String', [num2str(nMatch), ' files found in: ', folder]);
% --- Executes on button press in pbMakeList.
function pbMakeList_Callback(hObject, eventdata, handles)
% hObject    handle to pbMakeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable' , 'off')
resDir = '_Quantified Results';
mkdir(handles.IniPars.initialDir, resDir);
SaveDir = [handles.IniPars.initialDir, '\', resDir];

set(findobj('Tag', 'stStatus'), 'String', 'Integrating into list, please wait ...');

OutputOptions.mean      = get(findobj('Tag', 'cbMean'), 'Value');
OutputOptions.median    = get(findobj('Tag', 'cbMedian'),'Value');
OutputOptions.mode      = get(findobj('Tag', 'cbMode'), 'Value');
OutputOptions.format    = 'list';

if (get(findobj('Tag', 'rbFD10'), 'Value'))
    OutputOptions.sInstrument = 'FD10';
elseif (get(findobj('Tag', 'rbPS96'), 'Value'))
    OutputOptions.sInstrument = 'PS96';
elseif(get(findobj('Tag', 'rbPS4'), 'Value'))
    OutputOptions.sInstrument = 'PS4';
end


IIntegrate(SaveDir, handles.FileList, OutputOptions, handles.cOn, handles.cOff);


guidata(hObject, handles);
set(hObject, 'Enable', 'on');
nMatch = length(handles.FileList);
folder = handles.IniPars.initialDir;
set(findobj('Tag', 'stStatus'), 'String', [num2str(nMatch), ' files found in: ', folder]);


% --- Executes on button press in pbMakeV.
function pbMakeV_Callback(hObject, eventdata, handles)
% hObject    handle to pbMakeV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Enable', 'off')


function IIntegrate(SaveDir, FileList, OutputOptions, cOn, cOff)

nFiles = length(FileList);
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
        meanSig     = [];
        meanBg      = [];
        medianSig   = [];
        medianBg    = [];
        modeSig     = [];
        modeBg      = [];
    
    end   
    [cData, rFlag] = imgReadFile(FileList(n).fPath, nSpots, nCols);
    
    if (rFlag ~= -1)
        i = i+1;
        
        if isequal(OutputOptions.format, 'kinetics')
            C(i) = fname2cycle(FileList(n).fPath, OutputOptions.sInstrument);
        elseif isequal(OutputOptions.format, 'list')
            C(i) = cellstr(FileList(n).fPath);
        end
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
    
    if isequal(OutputOptions.format, 'kinetics')
        rBase = fname2rbase(FileList(n).fPath, OutputOptions.sInstrument);
    elseif isequal(OutputOptions.format, 'list')
        rBase =  'list';
    end
        
    hIndicator = findobj('Tag', 'frIndicator');    
    if FileList(n).isLast | n == length(FileList)
        set(hIndicator, 'BackgroundColor', cOn);
        drawnow
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
       
        set(hIndicator, 'BackgroundColor', cOff);
        drawnow
        bNextDir = 1; 
        i = 0;
    end
    
    
end  

uiwait(msgbox(['Results are saved in: ',SaveDir],'II','modal'));



function SaveData(fileName, saveFormat,x, y, geneID, row, col)





switch saveFormat
    case 'kinetics'
        WriteKinetics(fileName, x, y, geneID, row, col);
    case 'list'
        WriteList(fileName, x, y, geneID, row, col, 'a');
        
        
end

