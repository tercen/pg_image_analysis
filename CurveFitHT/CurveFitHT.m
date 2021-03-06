function varargout = CurveFitHT(varargin)
% compile
% mcc -m -d [dest dir] CurveFitHT CurveFitHT_pragma
% RdW2004, PamGene International, CurveFitHT vs1.0 
% CURVEFITHT M-file for CurveFitHT.fig
%      CURVEFITHT, by itself, creates a new CURVEFITHT or raises the existing
%      singleton*.
%
%      H = CURVEFITHT returns the handle to a new CURVEFITHT or the handle to
%      the existing singleton*.
%
%      CURVEFITHT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVEFITHT.M with the given input arguments.
%
%      CURVEFITHT('Property','Value',...) creates a new CURVEFITHT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CurveFitHT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CurveFitHT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CurveFitHT

% Last Modified by GUIDE v2.5 01-Apr-2005 11:25:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CurveFitHT_OpeningFcn, ...
                   'gui_OutputFcn',  @CurveFitHT_OutputFcn, ...
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


% --- Executes just before CurveFitHT is made visible.
function CurveFitHT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CurveFitHT (see VARARGIN)

% Choose default command line output for CurveFitHT
handles.output = hObject;

% below the initialization function for CurveFitHT
% at the end of this fucntion control will be rendered to the user via the
% GUI or 
% if (command line) parameters were specified, autorun will be started
% CurveFitHT 
% 'data' 'C:\' - if not specified user will be prompted
% 'vfile' 'C:\vFile.v' - if not specified user will be prompted
% 'setup' 'C:\setup.cset' - if not specified iniPars.dftSetupFile will be
% used.

handles.stdBlue = [0.9412, 0.9961,1.0000];

set(findobj('Tag', 'miPrefUpdate'), 'Checked', 'on')
set(findobj('Tag', 'pbNext'), 'Enable', 'off');
set(findobj('Tag', 'pbPrevious'), 'Enable', 'off');
set(findobj('Tag', 'pbAll'), 'Enable','off', 'UserData', 0);
set(findobj('Tag', 'pbCurrent'), 'Enable','off');
set(findobj('Tag', 'puUseX'), 'String', ' ', 'Enable', 'off');
set(findobj('Tag', 'puEndLevel'), 'String', ' ', 'Enable', 'off');
set(findobj('Tag', 'puDerivative'), 'String', ' ', 'Enable', 'off');
set(findobj('Tag', 'lbData'), 'String', ' ');
set(findobj('Tag', 'miSaveSetup'), 'Enable' ,'off');
% fitmodels

%default ini pars
iniPars.ModelFile = 'cfModels.ini';
iniPars.DataDir   = 'C:\';
iniPars.DftTolerance = 0.01;
iniPars.FitDisplay = 'off';
iniPars.DftMaxFunEvals = 200;
iniPars.DftMethod = 'Normal';
iniPars.sInstrument = 'Detect';
iniPars.strRefID    = '290-100';
iniPars.qcSpecMinLocalT          =   -2.5;
iniPars.qcSpecMaxLocalT          =   3.5;
iniPars.qcSpecMaxLocalCV           = 0.25 ;
iniPars.qcSpecMaxXw                 = 100;
iniPars.resHistNumOfBins = 10;
iniPars.dftFileFilter = '*mBg.dat';
iniPars.dftSetupFile = 'cfAutorun.cset'; % setup file is used for autorun
iniPars.saveLocationSetupFile = 'C:\';


handles.iniName = 'CurveFitHT.ini';
[iniPars, inifID] = getparsfromfile(handles.iniName, iniPars);

if inifID == -1,inifID ;end

stModels= cfGetModels(iniPars.ModelFile);
if isempty(stModels)
     uiwait(errordlg(['Could not open model file: ', fname, '!!! Press OK to terminate'],'CurveFit Error'));
     delete(gcf);
     return;
end
handles.iniPars     = iniPars;
set(findobj('Tag', 'edTolerance'), 'String', iniPars.DftTolerance, 'Enable', 'off');
handles.dataFilter = iniPars.dftFileFilter;
set(findobj('Tag', 'edFilter'), 'String', handles.dataFilter);

nModels = length(stModels);
clModelNames = cell(nModels,1);
[clModelNames{:}] = deal(stModels(:).ModelName);
handles.Instrument = 'PS96';

if (~isempty(clModelNames))
    set(findobj('Tag', 'puModel'), 'String', clModelNames);
end

handles.hPlot = [];
handles.stModels = stModels;
handles.versionStr  = 'CurveFitHT v1.76';

cfFitOpts.offsetX   = 0;
cfFitOpts.offsetY   = 0;
cfFitOpts.TolX      = iniPars.DftTolerance;
cfFitOpts.MaxFunEvals = iniPars.DftMaxFunEvals;
cfFitOpts.FitDisplay = iniPars.FitDisplay;
cfFitOpts.strMethod = iniPars.DftMethod;
handles.cfFitOpts = cfFitOpts;

QcSpec.minLocalT    = iniPars.qcSpecMinLocalT;
QcSpec.maxLocalT    = iniPars.qcSpecMaxLocalT;
QcSpec.maxLocalCV   = iniPars.qcSpecMaxLocalCV;
QcSpec.maxXw        = iniPars.qcSpecMaxXw;
handles.QcSpec = QcSpec;

if isequal(cfFitOpts.strMethod, 'Normal')
    set(findobj('Tag', 'rbFast'), 'Value' , 1);
    set(findobj('Tag', 'rbRobust'), 'Value', 0);
elseif isequal(cfFitOpts.strMethod, 'Robust')
    set(findobj('Tag', 'rbFast'), 'Value' , 0);
    set(findobj('Tag', 'rbRobust'), 'Value', 1);
else
    set(findobj('Tag', 'rbFast'), 'Value' , 1);
    set(findobj('Tag', 'rbRobust'), 'Value', 0);
end

guidata(hObject, handles);

 if ~isempty(varargin)
  iMatch = strmatch('data', varargin);
  if ~isempty(iMatch)
      dataDir = char(varargin(iMatch+1));
  else 
      dataDir = [];
  end
  iMatch = strmatch('vfile', varargin);
  if ~isempty(iMatch)
      vFileName = char(varargin(iMatch+1));
  else
      vFileName = [];
  end
  iMatch = strmatch('setup', varargin);
  if ~isempty(iMatch)
      setupFileName = char(varargin(iMatch+1));
  else
      setupFileName = iniPars.dftSetupFile;
  end
   
  handles = cfAutoRun(handles, dataDir, vFileName, setupFileName); 
end

% UIWAIT makes CurveFitHT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function CloseFcn(hObject, eventdata, handles)
SetIniPars(handles.iniName, handles.iniPars);
closereq;

% --- Outputs from this function are returned to the command line.
function varargout = CurveFitHT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = cellstr('End CurveFitHT');


% --- Executes on button press in pbGetData.
function pbGetData_Callback(hObject, eventdata, handles)
% hObject    handle to pbGetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'off');

if ~ischar(handles.iniPars.DataDir)
    handles.iniPars.DataDir = 'C:\';
end

dataDir = uigetdir(handles.iniPars.DataDir, 'select data directory');
if ischar(dataDir)
    handles.iniPars.DataDir = dataDir;
    handles = initializeData(handles);
end    
set(hObject, 'Enable', 'on')
guidata(hObject, handles);

function handles = initializeData(handles)    

    fdata = dir([handles.iniPars.DataDir,'\',handles.dataFilter]);
    nData = length(fdata);
    
    if (nData == 0)
        uiwait(errordlg(['No data found with: ',[handles.iniPars.DataDir,'\',handles.dataFilter]] ,'CurveFitHT - No Data','modal'));
        handles.nData = 0;
        return;
    end
    
    [hdr, data] = hdrload([handles.iniPars.DataDir,'\',fdata(1).name]);
    cHdr = strread(hdr, '%s', 'delimiter','\t');
    [cHdr, dIndex] = sortrows(cHdr);
    set(findobj('Tag', 'lbData'), 'String', cHdr, 'Value', 1); 
    set(findobj('Tag','stData'), 'String', handles.iniPars.DataDir);
   
   x = data(:,1);
   set(findobj('Tag', 'puUseX'), 'String', num2str(x), 'Enable', 'on', 'Value', [1:length(x)]);
   set(findobj('Tag', 'puEndLevel'), 'String', num2str(x), 'Enable', 'on', 'Value', length(x));
   set(findobj('Tag', 'puDerivative'), 'string', num2str(x), 'Enable', 'on', 'Value', 1);
   set(findobj('Tag', 'edTolerance'), 'Enable', 'on');
   set(findobj('Tag','pbNext'), 'Enable', 'on');
   set(findobj('Tag','pbPrevious'), 'Enable','on');
   set(findobj('Tag', 'lbdata'), 'Value', 1);
  
   
   handles.dIndex = dIndex; 
   handles.fdata = fdata;
   handles.nData = nData;
   handles.dataset = 0;
   handles.SelectedData = handles.dIndex(1);
   handles.SelectedID   = 1;
   handles.data = [];



% --- Executes during object creation, after setting all properties.
function lbData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lbData.
function lbData_Callback(hObject, eventdata, handles)
% hObject    handle to lbData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbData

val = get(hObject, 'Value');
set(findobj('Tag','pbNext'), 'Enable', 'on');
set(findobj('Tag','pbPrevious'), 'Enable','on');
handles.SelectedData = handles.dIndex(val);
handles.SelectedID   = val;
guidata(hObject, handles);
% --- Executes on button press in pbNext.
function pbNext_Callback(hObject, eventdata, handles)
% hObject    handle to pbNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.dataset = handles.dataset + 1;
if handles.dataset > handles.nData
    handles.dataset = 1;
end
handles = SetData(handles);
handles.hPlot = [];
set(findobj('Tag', 'lbFitParameters'), 'String', '');
guidata(hObject, handles);
if (get(findobj('Tag','cbAutoFit'),'Value'))
    pbCurrent_Callback(hObject, [], handles)
end

function pbPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to pbPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pbPrevious.
handles.dataset = handles.dataset-1;
if (handles.dataset < 1)
    handles.dataset = handles.nData;
end
handles = SetData(handles);
handles.hPlot = [];
set(findobj('Tag', 'lbFitParameters'), 'String', '');
guidata(hObject, handles);   

if (get(findobj('Tag','cbAutoFit'),'Value'))
    pbCurrent_Callback(hObject, [], handles)
end

function handles = SetData(handles, bFitAll)
persistent oldHdr
% previous hdr line is kept between calls to check for consistency

% if bFitAll = 1, SetData is called form the FitAll function
% this affects the way data inconsistency is handled in SetData
if nargin == 1
    bFitAll = 0;
end

fdata = handles.fdata;
[hdr, data] = hdrload([handles.iniPars.DataDir,'\',fdata(handles.dataset).name]);

% check for consistency

if isempty(handles.data)
    handles.bConsistent = 1;
elseif isequal(fdata(handles.dataset).name(1:4), '_All')
    handles.bConsistent = 1;
elseif length(data(:,1)) ~= length(handles.data(:,1))
    handles.bConsistent = 0;
elseif data(:,1) ~= handles.data(:,1)
    handles.bConsistent = 0;
elseif length(hdr) ~= length(oldHdr)
    handles.bConsistent = 0;
elseif ~isequal(hdr, oldHdr)
    handles.bConsistent = 0;
else
    handles.bConsistent = 1;
end

if handles.bConsistent
    handles.data = data;
    oldHdr = hdr;
    x = data(:,1);   
end

if ~handles.bConsistent & ~bFitAll
    % data inconsistent reset.
  
    cHdr = strread(hdr, '%s', 'delimiter','\t');
    [cHdr, dIndex] = sortrows(cHdr);
    handles.dIndex = dIndex; 
    handles.SelectedData = handles.dIndex(1);
    set(findobj('Tag', 'puUseX'), 'String', num2str(x), 'Enable', 'on', 'Value', [1:length(x)]);
    set(findobj('Tag', 'puEndLevel'), 'String', num2str(x), 'Enable', 'on', 'Value', length(x));
    set(findobj('Tag', 'puDerivative'), 'string', num2str(x), 'Enable', 'on', 'Value', 1);
    set(findobj('Tag', 'edTolerance'), 'Enable', 'on');
    set(findobj('Tag','pbNext'), 'Enable', 'on');
    set(findobj('Tag','pbPrevious'), 'Enable','on');
    set(findobj('Tag', 'lbdata'), 'Value', 1);
    set(findobj('Tag', 'lbData'), 'String', cHdr, 'Value', 1); 
end

y = data(:,handles.SelectedData);
handles.dataname = fdata(handles.dataset).name;
if ~bFitAll
    axes(findobj('Tag', 'axData'));
    h = gca;
    hold off
    plot(x,y,'.')
    title(fdata(handles.dataset).name, 'Interpreter','none');
    set(h, 'Tag', 'axData');
end

set(findobj('Tag', 'pbAll'), 'Enable','on');
set(findobj('Tag', 'pbCurrent'), 'Enable','on');
set(findobj('Tag', 'miSaveSetup'), 'Enable', 'on');   

% --- Executes during object creation, after setting all properties.
function puModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in puModel.
function puModel_Callback(hObject, eventdata, handles)
% hObject    handle to puModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puModel


% --- Executes during object creation, after setting all properties.
function puUseX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puUseX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in puUseX.
function puUseX_Callback(hObject, eventdata, handles)
% hObject    handle to puUseX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puUseX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puUseX
vUseX = get(hObject,'Value');
hDer = findobj('Tag', 'puDerivative');
vDerivative = get(hDer, 'Value');

minX = vUseX(1);
maxX = vUseX(length(vUseX));

if vDerivative < minX
    vDerivative = minX;
elseif vDerivative > maxX;
    vDerivative = maxX;
end
set(hDer, 'Value', vDerivative);

% --- Executes during object creation, after setting all properties.
function puEndLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in puEndLevel.
function puEndLevel_Callback(hObject, eventdata, handles)
% hObject    handle to puEndLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puEndLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puEndLevel

% --- Executes during object creation, after setting all properties.
function edFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edFilter_Callback(hObject, eventdata, handles)
% hObject    handle to edFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edFilter as text
%        str2double(get(hObject,'String')) returns contents of edFilter as a double

handles.dataFilter = get(hObject,'String');
pbGetData_Callback(findobj('Tag', 'pbGetData'), eventdata, handles);

% --- Executes during object creation, after setting all properties.
function puDerivative_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puDerivative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in puDerivative.
function puDerivative_Callback(hObject, eventdata, handles)
% hObject    handle to puDerivative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puDerivative contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puDerivative
% --- Executes on button press in pbAll.

vDerivative = get(hObject,'Value');
vUseX = get(findobj('Tag', 'puUseX'), 'Value');

minX = vUseX(1);
maxX = vUseX(length(vUseX));

if vDerivative < minX
    vDerivative = minX;
elseif vDerivative > maxX;
    vDerivative = maxX;
end
set(hObject, 'Value', vDerivative);



function pbAll_Callback(hObject, eventdata, handles)
% hObject    handle to pbAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pbAll.

% this links trough to the cfFitAll function
handlesOut = cfFitAll(hObject, handles);
guidata(hObject, handlesOut);


function handles = cfFitAll(hFitAllButton, handles, vFileName, setupFileName)
% This function is used to call inititiate a 'Fit All', either via the user
% pressing the Fit All button or via command line input. Not that the function needs the 'handle graphics' handles for the 'Fit All'
% button. 
% If vFileName is specified the function saves the v-file as the
% specified file, otherwise the user is prompted to specify.
% hObject -> UserData is used to keep track if the push button is pushed a
% second time to invoke a cancek



if  get(hFitAllButton, 'UserData') == 0
    % pressed 'first' time, initialize fitting

    if nargin == 2 | ( nargin == 4 & isempty(vFileName) )
        % if vFileName not specified, ask user.
        [vFile, vPath] = uiputfile([handles.iniPars.DataDir,'\*.v'], 'Save results as ...');   
        if (vFile == 0)
            % user pressed cancel on file selection
            set(hFitAllButton, 'String', 'Fit All', 'ForegroundColor',  handles.stdBlue, 'UserData', 0, 'Enable', 'on');
            set(gcf, 'Pointer', 'arrow');
            enableGui('on');
            return;
        else
            % check if user filled out extension, else add .v
            iPoint = findstr(vFile, '.');
            if isempty(iPoint)
                vFile = [vFile,'.v'];
            end
            vFileName = [vPath,'\',vFile];
        end
    end
    if nargin < 4
        setupFileName = [];
    end

    set(hFitAllButton, 'String', 'Cancel', 'ForegroundColor', [0.6, 0, 0.1], 'UserData' , 1);
    set(gcf, 'Pointer', 'watch');
    enableGui('off');
    drawnow

else
    % this is second button press initiate cancel
    set(hFitAllButton, 'UserData', -1, 'Enable', 'off');
    drawnow;
    return
end
vAll = struct([]);
% clLog will be used as hdr to the v-file
clLog{1} = cellstr('logBegin');

cUpdate = get(findobj('Tag','miPrefUpdate'), 'Checked');
if isequal(cUpdate, 'on');
    bUpdate = 1;
else
    bUpdate = 0;
end

% import settings from GUI
[cSet, cfOpts, dummy, QcSpec] = cfGetSettings(handles, setupFileName);
% note that th structures cSet and cfOPts, together with QcSpec
% define the fit settings.

% loop trough the datasets
allPoints = [];
allRelRes = [];
for i = 1:handles.nData;
    handles.dataset = i;
    handles = SetData(handles, 1);

    h = gca;
    axes(h);
    set(h, 'Tag', 'axData');

 
    if handles.bConsistent
        [x,y] = cfGetCurrentData(handles);
        title(handles.dataname, 'Interpreter', 'none');
        [v, fit, handles.absRes, handles.relRes] = vMakeFit(x,y,cSet, cfOpts, handles.dataname, handles.iniPars.sInstrument);
        [sRes1, sRes2] = size(handles.relRes);
        allRelRes = [allRelRes, handles.relRes(:,2:sRes2)];
        if v(1).Index1 ~= -1
            vAll = [vAll,v];
        else
            % handles.dataname was not recognized.
            lStr = ['Skipped: ',handles.dataname,': indices could not be assigned.'];
            clLog{length(clLog)+1} = cellstr(lStr);
        end

        if(bUpdate)
            hold off
            plot(x, y,'.')
            title(handles.dataname, 'Interpreter', 'none');
            hold on
            nCol = size(y); nCol = nCol(2);
            for j=1:nCol
                hPlot(j) = cfPlotFit(x, fit(:,j), v(j), cSet);
            end
            handles.hPlot = hPlot;
            vl = vList(v, ' : ');
            cListVal = get(findobj('Tag', 'lbFitParameters'), 'Value');
            if cListVal > length(vl), cListVal = 1; end;

            set(findobj('Tag', 'lbFitParameters'), 'String',char(vl), 'Value', cListVal);
            drawnow
        end

        % check if cancel pressed
        if get(hFitAllButton, 'UserData') == -1
            break
        end
    else
            % if ~handles.bConsistent, the current datafile was found to be
            % inconsistent: skip and add to log in v-file
            lStr = ['Skipped: ',handles.dataname,': data file is inconsistent'];
            clLog(length(clLog)+1) = cellstr(lStr);
    end
end




if get(hFitAllButton, 'UserData') ~= -1
    % now recalculate the wChiSqr based on all residuals

    clLog{length(clLog)+1} = cellstr('logEnd');
    vGen = vGeneral(handles, cSet, cfOpts);
    
    bDoQC = get(findobj('Tag', 'miDoQc'), 'Checked');
    if isequal(bDoQC, 'on')
        [vAll, vGenEntries, strRefID]= cfGlobalQC(vAll, handles.iniPars.strRefID);
        if ~isempty(strRefID)
            handles.iniPars.strRefID = strRefID;
        end
        if ~isempty(vGenEntries)
            clNames = fieldnames(vGenEntries);
            for n = 1:length(clNames)
                vGen.(clNames{n}) = vGenEntries.(clNames{n});
            end
            vAll = vAddQcFlags(vAll, QcSpec);
        end
        
        
    end
        
    
    
    fid = vWrite(vFileName, vAll, vGen, clLog);
    if (fid == -1)
        uiwait(msgbox(['Failed to save results to: ',vFileName], 'CurveFitHT Error !', 'modal'));
    else
        uiwait(msgbox(['Results saved to: ', vFileName],'Finished Fitting !','modal'));
    end
 
end
set(h, 'Tag', 'axData');
set(hFitAllButton, 'String', 'Fit All', 'ForegroundColor',  handles.stdBlue, 'UserData', 0, 'Enable', 'on');
set(gcf,'Pointer','arrow');
enableGui('on');
drawnow

% --- Executes on button press in pbCurrent.
function pbCurrent_Callback(hObject, eventdata, handles)
% hObject    handle to pbCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable', 'off');
enableGui('off');
set(gcf, 'Pointer', 'watch');


[cSet, cfOpts] = cfGetSettings(handles);

[x,y] = cfGetCurrentData(handles);

h = findobj('Tag', 'axData');
hold off
plot(x, y, '.')
hold on
axes(h);
nData = size(y); nData = nData(2);
title(handles.dataname, 'Interpreter', 'none');
[v, fit, aRes, rRes] = vMakeFit(x,y,cSet, cfOpts, handles.dataname, handles.iniPars.sInstrument);    
handles.absRes = aRes;
handles.relRes = rRes;

for j=1:nData
    hPlot(j) = cfPlotFit(x, fit(:,j), v(j), cSet);
end

vl = vList(v,' : ');
%cListVal = get(findobj('Tag', 'lbFitParameters'), 'Value');
%if cListVal > length(vl), cListVal = 1; end;
cListVal = 1;
set(findobj('Tag', 'lbFitParameters'), 'String',char(vl), 'Value', cListVal);     

handles.hPlot = hPlot;
guidata(hObject, handles); 
set(h, 'Tag', 'axData');    
set(hObject, 'Enable', 'on');        
enableGui('on');
set(gcf, 'Pointer', 'arrow');

function [Xdata,Ydata] = cfGetCurrentData(handles)
data = handles.data;
Xdata = data(:,1);
Ydata = data(:,handles.SelectedData);

function [v, fit, absRes, relRes] = vMakeFit(x,y,Settings, cfOpts, dataname, sInstrument)

pName = Settings.Model.Parameter;
nData = size(y); nData = nData(2);
vUsed = Settings.vUseX;
xUsed = x(vUsed);
xDerivative = x(Settings.vDerivative);
vDerivative = find(xUsed == xDerivative);



for i = 1:nData
    yUsed = y(vUsed,i);
    
    
    [p(:,i), ExitFlag, wOut] = cfFit(xUsed-cfOpts.offsetX,yUsed - cfOpts.offsetY,[], Settings.Model.FunctionName, cfOpts);
    [fit(:,i),j, V] = feval(Settings.Model.FunctionName, xUsed - cfOpts.offsetX, [], p(:,i));
    
    absRes(:,i) = (yUsed - fit(:,i));
    
    warning('off','MATLAB:divideByZero')
    relRes(:,i) =  absRes(:,i)./yUsed;
    warning('on','MATLAB:divideByZero')
    aChiSqr     = sum(absRes(:,i).^2);

    % make results vector for this fit
    v(i).ID = Settings.clCurrentID{i};
    v(i).QcFlag = '';
    [r,c] = fname2rc(dataname,sInstrument);
    if ~isempty(r) &~isempty(c)
        v(i).Index1 = r;
        v(i).Index2 = c;
    else
        v(i).Index1 = -1;
        v(i).Index2 = -1;
    end
         
    for nPar = 1:length(p(:,i))
        strfld = char(pName(nPar));
        v(i).(strfld) = p(nPar,i);
    end
    if ~isempty(vDerivative)
        v(i).Vini = V(vDerivative);
    else
        v(i).Vini = [];
    end
    
    iOut = isnan(relRes(:,i)) | isinf(relRes(:,i));
    
   
    v(i).EndLevel       =  mean(y(Settings.vEndLevel,i) );       
    v(i).R2             =  CalcR(fit(:,i), yUsed);
    v(i).aChiSqr        =  aChiSqr/length(yUsed);
    v(i).rChiSqr        =  sum(relRes(~iOut,i).^2);
%   v(i).sChiSqr        =  sum( (relRes(~iOut,i)/std(relRes(~iOut,i))).^2);;
    v(i).t              = median(absRes)/std(absRes);
    v(i).sSig           =   std(yUsed - median(yUsed));
%   v(i).pRuns          =  runsTest(absRes(:,i));
    v(i).N              =  length(yUsed);
    v(i).QcFlag         =  0;
              
    
end




  

relRes = [xUsed, relRes];
absRes = [xUsed, absRes];

function hPlot = cfPlotFit(x, fit, v, Settings)
hPlot = plot(x(Settings.vUseX),fit );
axLim = axis;
% plot Vini tangent if appropriate
if  ~isempty(v.Vini)
    xDerivative = x(Settings.vDerivative);
    vDerivative = find(x(Settings.vUseX) == xDerivative);
    xPlot = x;
    if vDerivative+2 > length(xPlot)
        dX = xPlot(end) - xPlot(end-1);
        last = xPlot(end);
        xPlot = [xPlot;last+dX;last+2*dX];
    end
    vx = [xPlot(Settings.vDerivative),xPlot(Settings.vDerivative+2)];
    dx  = xPlot(Settings.vDerivative+2) - xPlot(Settings.vDerivative);
    vy = [fit(vDerivative),fit(vDerivative) + v.Vini*dx];
    plot(vx, vy, 'm');
    axis(axLim);
end
% plot measured end level

eLx = x(Settings.vEndLevel);
if length(eLx == 1)
    eLx =  [eLx-2, eLx-1, eLx];
end
eLy = v.EndLevel * ones(size(eLx));
plot(eLx, eLy, 'k');

function vG     = vGeneral(handles, settings, cfopts)
vG.generalID     = handles.iniPars.DataDir;
vG.Date         = date;
vG.Generated_By = handles.versionStr;
vG.FitModel     = settings.Model.FunctionName;
vG.Tolerance    = cfopts.TolX;
vG.OffsetX      = cfopts.offsetX;
vG.OffsetY      = cfopts.offsetY;

sxUsed        = [];
for i=1:length(settings.vUseX)
    sxUsed = [sxUsed,num2str(settings.vUseX(i)),';'];
end
vG.iXused           = sxUsed;
vG.iDerivative      = settings.vDerivative;



svEndLevel = [];
for i=1:length(settings.vEndLevel)
    svEndLevel = [svEndLevel, num2str(settings.vEndLevel(i)),';'];
end
vG.iEndLevel    = svEndLevel;

% function decFlag = makeQcFlag(v, QcSpec);
% 
% 
% flag = '00000000';
% % in case flag is not zero bit 8 is always set
% %  (f(BitDepth))
% % plus another one referring to the reason for flagging
% 
% 
% fBitDepth = length(flag);
% if v.R2 < QcSpec.minimalR2
%     %'[]101';
%     flag(fBitDepth) = '1';
%     flag(fBitDepth - 2) = '1';
% end
% 
% if v.Vini <QcSpec.minimalVini;
%     %'[]1001'
%     flag(fBitDepth) = '1';
%     flag(fBitDepth - 3) = '1';
% end
% 
% if v.EndLevel < QcSpec.minimalEndLevel
%     %[]10001'
%     flag(fBitDepth) = '1';
%     flag(fBitDepth - 4) = '1';
% end
% decFlag = bin2dec(flag);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function lbFitParameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbFitParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lbFitParameters.
function lbFitParameters_Callback(hObject, eventdata, handles)
% hObject    handle to lbFitParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbFitParameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        lbFitParameters
hPlot = handles.hPlot;
if isempty(hPlot)
    return;
end
val = get(hObject, 'Value');
for i = 1:length(hPlot)
    if (i+1 == val) 
        set(hPlot(i), 'Color', 'r');
    else
        set(hPlot(i), 'Color', 'b');
    end
end
    
% --------------------------------------------------------------------
% --- Executes on button press in cbAutoFit.
function cbAutoFit_Callback(hObject, eventdata, handles)
% hObject    handle to cbAutoFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAutoFit


% --- Executes on button press in cdUpdate.







function mFile_Callback(hObject, eventdata, handles)
    


function mPreferences_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function miPrefUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to miUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cVal = get(hObject, 'Checked');
if isequal(cVal, 'on')
    set(hObject, 'Checked', 'off')
elseif isequal(cVal, 'off')
    set(hObject, 'Checked', 'on')
end

% --------------------------------------------------------------------
function miDoQc_Callback(hObject, eventdata, handles)
% hObject    handle to miDoQc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cVal = get(hObject, 'Checked');
if isequal(cVal, 'on')
    set(hObject, 'Checked', 'off')
elseif isequal(cVal, 'off')
    set(hObject, 'Checked', 'on')
end


function miPrefAdvanced_Callback(hObject, eventdata, handles)



hSettings = AdvancedSettings(handles.cfFitOpts.strMethod, handles.cfFitOpts.TolX, handles.cfFitOpts.offsetX, ...
    handles.cfFitOpts.offsetY, handles.cfFitOpts.MaxFunEvals);
drawnow;
waitfor(hSettings, 'Visible');
NewAdvancedSettings = guidata(hSettings);
if isequal(NewAdvancedSettings.bPressed, 'OK')
    handles.cfFitOpts.strMethod = NewAdvancedSettings.strMethod;
    handles.cfFitOpts.TolX      = NewAdvancedSettings.Tolerance;
    handles.cfFitOpts.offsetX   = NewAdvancedSettings.offsetX;
    handles.cfFitOpts.offsetY   = NewAdvancedSettings.offsetY;
    handles.cfFitOpts.MaxFunEvals = NewAdvancedSettings.MaxFunEvals;
end

guidata(hObject,handles);
delete(hSettings);

% --------------------------------------------------------------------
function miFileAbout_Callback(hObject, eventdata, handles)
% hObject    handle to miFileAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aboutStr = [handles.versionStr,' (c) 2004 PamGene International BV']; 
uiwait(msgbox(aboutStr, 'About CurveFitHT ...'));


% % --------------------------------------------------------------------
% function miFitQC_Callback(hObject, eventdata, handles)
% % hObject    handle to miFitQC (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% hQcSettings = QCSettings(handles.QcSpec.minimalR2, handles.QcSpec.minimalEndLevel, handles.QcSpec.minimalVini);
% drawnow;
% waitfor(hQcSettings, 'Visible');
% NewQcSettings = guidata(hQcSettings);
% if isequal(NewQcSettings.bPressed, 'OK')
%     handles.QcSpec.minimalR2 = NewQcSettings.minimalR2;
%     handles.QcSpec.minimalEndLevel = NewQcSettings.minimalEndLevel;
%     handles.QcSpec.minimalVini = NewQcSettings.minimalVini;
% end
% guidata(hObject,handles);



% --------------------------------------------------------------------
function cmiShowResplot_Callback(hObject, eventdata, handles)
% hObject    handle to cmiShowResplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(findobj('Tag','lbFitParameters'), 'Value');
uiwait(resPlot(handles.absRes(:, [1,val]), handles.relRes(:,[1,val]) ));


% --------------------------------------------------------------------
function cmiShowResHist_Callback(hObject, eventdata, handles)
% hObject    handle to cmiShowResHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(findobj('Tag', 'lbFitParameters'), 'Value');
uiwait(histPlot(handles.absRes(:,val), handles.relRes(:, val), handles.iniPars.resHistNumOfBins ));

% --------------------------------------------------------------------
function cmlbData_Callback(hObject, eventdata, handles)
% hObject    handle to cmlbData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function enableGui(strEnable)
set(findobj('Tag','puUseX'), 'Enable', strEnable);
set(findobj('Tag','puEndLevel'), 'Enable', strEnable);
set(findobj('Tag','puDerivative'), 'Enable', strEnable);
%set(findobj('Tag','puModel'), 'Enable', strEnable);
set(findobj('Tag','mFile'), 'Enable', strEnable);
set(findobj('Tag','mPreferences'), 'Enable', strEnable);
set(findobj('Tag','pbNext'), 'Enable', strEnable);
set(findobj('Tag','pbPrevious'), 'Enable', strEnable);
set(findobj('Tag','pbGetData'), 'Enable', strEnable);
set(findobj('Tag','pbCurrent'), 'Enable', strEnable);
set(findobj('Tag','lbData'), 'Enable', strEnable);
set(findobj('Tag','lbFitParameters'), 'Enable', strEnable);
set(findobj('Tag','edFilter'), 'Enable', strEnable);


% --------------------------------------------------------------------
function miSaveSetup_Callback(hObject, eventdata, handles)
% hObject    handle to miSaveSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fExt = '.fset';
[fName, fPath] = uiputfile([handles.iniPars.saveLocationSetupFile,'\*',fExt], 'Save Settings As ... ')

if ischar(fName)
    iPoint = findstr(fName, '.');
    if isempty(iPoint)
        fName = [fName,fExt];
    end
    [Settings, Options, dataFilter, QcSpec] = cfGetSettings(handles);
    Settings.SelectedData   = handles.SelectedData;
    Settings.SelectedID     = handles.SelectedID;
    handles.iniPars.saveLocationSetupFile = fPath;
    try
        save([fPath, '\', fName], 'Settings', 'Options','dataFilter', 'QcSpec','-mat');
    catch
        errordlg(['Could not create settings file: ', [fPath,'\',fName]], 'CurveFitHT Error');
    end
end
guidata(hObject, handles);

function [Settings, Options, dataFilter, QcSpec] = cfGetSettings(handles, fSetup)
% This gets the fit Settings, Options and QC specs from
% 1. The GUI, if fSetup is not specified
% 2. The settings file fSetup if specified.

if nargin == 1 | isempty(fSetup)
    % read settings from the GUI
    QcSpec = handles.QcSpec;
    stModels = handles.stModels;
    vModel      = get(findobj('Tag', 'puModel'), 'Value');
    Settings.Model      = stModels(vModel);
    Settings.vUseX      = get(findobj('Tag', 'puUseX'), 'Value');
    Settings.vEndLevel  = get(findobj('Tag', 'puEndLevel'), 'Value');
    Settings.vDerivative = get(findobj('Tag', 'puDerivative'), 'Value');
    clSpotID    = get(findobj('Tag', 'lbData'),  'String');
    Settings.clCurrentID = clSpotID(handles.SelectedID);
    Settings.Instrument = handles.Instrument;
    Options = handles.cfFitOpts;
    dataFilter= handles.dataFilter;
else
    % load settings from file.
    try
        Setup = load(fSetup, '-mat');
        Settings    = Setup.Settings;
        Options     = Setup.Options;
        QcSpec      = Setup.QcSpec;
        dataFilter  = Setup.dataFilter;
            
    catch
        Settings = [];
        Options =  [];
        QcSpec =   [];
        dataFilter = [];
    end
end

function handles = cfAutoRun(handles, dataDir, vFileName, setupFileName)
[S, O,dataFilter, Q] = cfGetSettings([], setupFileName);
if ~isempty(dataFilter)
    if ~isempty(dataDir)
        handles.QcSpec = Q;
        handles.cfFitOpts = O;
		handles.iniPars.DataDir = dataDir;
        handles.dataFilter = dataFilter;
        handles.SelectedData    = S.SelectedData;
        handles.SelectedID =  S.SelectedID;
        handles = initializeData(handles);
        
        set(findobj('Tag', 'lbData'), 'Value', S.SelectedID);      
        mList = get(findobj('Tag', 'puModel'), 'String');
        iMatch = strmatch(char(S.Model.ModelName),mList);
        set(findobj('Tag', 'puModel'), 'Value', iMatch);
        set(findobj('Tag', 'puUseX'), 'Value', S.vUseX);
        set(findobj('Tag', 'puEndLevel'), 'Value', S.vEndLevel);
        set(findobj('Tag', 'puDerivative'), 'Value', S.vDerivative);
        handles.SelectedData = S.SelectedData;
        if handles.nData == 0
            return;
        end    
    else
       pbGetData_Callback(findobj('Tag', 'pbGetData'), [], handles)
    end
    handles = cfFitAll(findobj('Tag', 'pbAll'), handles, vFileName, setupFileName);
    CloseFcn(gcf, [], handles);
else
    uiwait(errordlg(['Could Not Autorun With: ',setupFileName ], 'CurveFitHT Error!'));
end

function v = vAddQcFlags(v, Specs);

flFlag          = bin2dec('00000001');
flBadWell       = bin2dec('00000010');
flLocalT        = bin2dec('00000100');
flLocalCV       = bin2dec('00001000');
flXw            = bin2dec('00010000');



for i=1:length(v)
    bFlag = 0;
    bBadWell = 0;
    
    if (v(i).localT < Specs.minLocalT) | (v(i).localT > Specs.maxLocalT)
        v(i).QcFlag = flLocalT;
        bFlag = 1;
        bBadWell = 1;
    end
    if v(i).localCV > Specs.maxLocalCV
        v(i).QcFlag = flLocalCV;
        bFlag = 1;
        bBadWell = 1;
    end
    if (v(i).aChiSqr / (v(i).N *v(i).sSig)) > Specs.maxXw
        v(i).QcFlag = flXw;
        bFlag = 1;
    end
    if bFlag
        v(i).QcFlag = v(i).QcFlag + flFlag;
    end
    if bBadWell
        v(i).QcFlag = v(i).QcFlag + flBadWell;
    end
end

        







