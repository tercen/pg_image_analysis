function varargout = gridManager(varargin)
% GRIDMANAGER M-file for gridManager.fig
%      GRIDMANAGER, by itself, creates a new GRIDMANAGER or raises the existing
%      singleton*.
%
%      H = GRIDMANAGER returns the handle to a new GRIDMANAGER or the handle to
%      the existing singleton*.
%
%      GRIDMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRIDMANAGER.M with the given input arguments.
%
%      GRIDMANAGER('Property','Value',...) creates a new GRIDMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gridManager_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gridManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gridManager

% Last Modified by GUIDE v2.5 02-Feb-2006 18:51:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gridManager_OpeningFcn, ...
                   'gui_OutputFcn',  @gridManager_OutputFcn, ...
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


% --- Executes just before gridManager is made visible.
function gridManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gridManager (see VARARGIN)

handles.iniFile = 'PamGrid7.ini';

iniPars.dataDir = 'C:\';
iniPars.imagesDir = 'C:\';
iniPars.templateDir = pwd;
iniPars.resDir  = '_Quantified';
iniPars.dftInstrument = 'detect';
iniPars.xResize = 256;
iniPars.yResize = 256;
iniPars.gridRefMarker = '#';
iniPars.dataSearchFilter = '*.tif*';
iniPars.dataForceStructure = 1;

iniPars.minRot = -2;
iniPars.maxRot = 2;
iniPars.dRot = 0.25;

iniPars.imageResultsExtension = 'pgr';
iniPars.segEdgeLowSensitivity = 0;
iniPars.segEdgeHighSensitivity = 0.005;
iniPars.segAreaSize = 0.7;

iniPars.spotSize = 0.66;
iniPars.minDiameter = 0.45;
iniPars.maxDiameter = 0.85;
iniPars.minFormFactor = 0.7;
iniPars.maxAspectRatio = 1.4;
iniPars.maxOffset= 0.35;

iniPars.ppSmallDisk = 0.17;
iniPars.ppLargeDisk = 0.51;
iniPars.ppCircle = 30;
iniPars.ppBlurr = 0.3;

iniPars.qBackgroundMethod = 'localCorner';
iniPars.outlierMethod = 'iqrBased';
iniPars.outlierMetric = 1.75;

handles.iniPars = getparsfromfile(handles.iniFile, iniPars);
handles.list = [];
handles.selectedWell = [];
handles.gridMode = 'kinLast';
% Choose default command line output for gridManager
handles.output = hObject;
handles.oArray = [];
handles.template = [];
handles.oArray = array();
handles.oP      = preProcess();
handles.segmentationMethod = 'Edge';
set(handles.miSegmentationEdge', 'checked', 'on');



set(gcf, 'position', [6.4 7.07692 95.4 29.3846]);
% Update handles structure
set(handles.pbAll, 'enable', 'off');
set(handles.pbThis, 'enable', 'off');
handles.version = 'alpha.7.1b';
miPreProcessingFast_Callback(handles.miPreProcessingFast, [], handles);
handles.prepMode = 'fast';
handles.seriesMode = 'fixed';
handles.spotWeight = 'equalize';

miFixedSegmentation_Callback(handles.miFixedSegmentation, [], handles);
strLabel = ['Edit Search Filter (',handles.iniPars.dataSearchFilter,')']; 
set(handles.miFilter, 'Label', strLabel);


guidata(hObject, handles);

% UIWAIT makes gridManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function Close(hObject, eData, handles)
SetIniPars(handles.iniFile, handles.iniPars);
closereq;
% --- Outputs from this function are returned to the command line.
function varargout = gridManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbThis.
function pbThis_Callback(hObject, eventdata, handles)
% hObject    handle to pbThis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.bShow = 1;
handles = analyze(hObject, handles);
set(handles.miExportCurrent, 'Enable', 'on');
guidata(hObject, handles);


% --- Executes on button press in pbAll.
function pbAll_Callback(hObject, eventdata, handles)
% hObject    handle to pbAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'enable', 'off');
if isequal(get(handles.miUpdate, 'checked'), 'off')
    handles.bShow = 0;
else
    handles.bShow = 1;
end

[nRows, nCols] = size(handles.arrays);
for i=1:nRows
    for j=1:nCols
        if handles.arrays(i,j).used
            well_Callback(handles.arrays(i,j).hPlot, [], handles);
            handles.selectedWell = [i,j];
            handles = analyze(hObject, handles);
            drawnow
            % export data if required
            if isequal(get(handles.miExportImages, 'checked'), 'on')
                bImages = 1;
            else
                bImages = 0;
            end
            if isequal(get(handles.miExportQuantified, 'checked'), 'on')
                bQuant = 1;
            else
                bQuant = 0;
            end

            exportWell(handles.expNames, handles.resBase, handles.expMode, handles.cAxis, handles.qImage, bImages, bQuant);
        
        end
    end
end




set(hObject, 'enable', 'on');


guidata(hObject, handles);

% --------------------------------------------------------------------
    function miLoadSet_Callback(hObject, eventdata, handles)
        % hObject    handle to miLoadSet (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        newDir = uigetdir(handles.iniPars.dataDir, 'Please, select a data set.');
        if newDir
            handles.iniPars.dataDir = newDir;
            try
                oData = dataSet('path', newDir, 'instrument', handles.iniPars.dftInstrument, ... 
                    'filter', handles.iniPars.dataSearchFilter, 'forceStructure',handles.iniPars.dataForceStructure );
                set(gcf, 'pointer', 'watch');
                drawnow;
                oData = getList(oData);
                list = get(oData, 'list');
                set(handles.stData, 'string', newDir);

                handles.list = list;
                handles.instrument = get(oData, 'instrument');
                imSize = get(oData, 'imageSize');

            catch
                set(gcf, 'pointer', 'arrow');
                [errstr, errid] = lasterr;
                errordlg(lasterr,'Load Failed !!!');
                return
            end
            % read instrument parameters and initialize array object
            instrumentFile = [handles.instrument,'.instrument'];
            try
                pars = readInstrumentParameters(instrumentFile);
            catch
                errordlg(lasterr);
                return
            end
            names = fieldnames(pars);
            for i=1:length(names)
                if isempty(pars.(names{i}))
                    errordlg('Instrument parameters were not properly initalized');
                    return;
                end
            end
            

           % Set array object , preprocessing object and segmentation
            % object with instrument specific parameters.
            spotPitch = pars.spotPitch;
            inipars = handles.iniPars;
            axRot = [inipars.minRot:inipars.dRot:inipars.maxRot];
            handles.oArray = set(handles.oArray, 'spotPitch', spotPitch, ...
                                                 'spotSize', inipars.spotSize * spotPitch, ...
                                                 'rotation', axRot);
                                             
            handles.oP = set(handles.oP, 'nCircle',spotPitch * inipars.ppCircle, ...
                                          'nLargeDisk', spotPitch * inipars.ppLargeDisk, ...
                                          'nSmallDisk', spotPitch* inipars.ppSmallDisk, ...
                                          'nBlurr', spotPitch * inipars.ppBlurr );
            
        
            
            es = [inipars.segEdgeLowSensitivity, inipars.segEdgeHighSensitivity];
            handles.oS = segmentation('areaSize', inipars.segAreaSize, ...
                                      'edgeSensitivity', es);
       
            oOut = outlier('method', inipars.outlierMethod , ...   
                           'measure', inipars.outlierMetric);
                       
            handles.oQ = spotQuantification('backgroundMethod', inipars.qBackgroundMethod, ...
                                            'oOutlier', oOut);
                                                                          
            %%% initialilzie exposure time popup
            uT = vGetUniqueID(list, 'T');
            set(handles.puIntegrationTime, 'String', uT);
            uF = vGetUniqueID(list, 'F');
            set(handles.puFilter', 'String', uF);
            %%%%%%%%%%%
            arrays = initializeDataSet(list, handles.instrument);
            arrays = initializeGraph(handles.axes1, arrays);

            handles.arrays = arrays;

            well_Callback(arrays(1,1).hPlot, [], handles);
            handles.selectedWell = [1,1];
            set(gcf, 'pointer', 'arrow');
            drawnow;

            strDir = [handles.iniPars.dataDir, '\', handles.iniPars.resDir];
            if ~exist(strDir, 'dir')
                mkdir(handles.iniPars.dataDir, handles.iniPars.resDir);
            end
            set(handles.miExportCurrent, 'Enable', 'off');
        end

        guidata(hObject, handles);

% --------------------------------------------------------------------
function miData_Callback(hObject, eventdata, handles)
% hObject    handle to miData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function miGrid_Callback(hObject, eventdata, handles)
% hObject    handle to miGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function miQuantification_Callback(hObject, eventdata, handles)
% hObject    handle to miQuantification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function miAbout_Callback(hObject, eventdata, handles)
% hObject    handle to miAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = ['PamGrid ', handles.version, ' (c)2005 PamGene International BV']; 
helpdlg(str, 'About ...');
function well_Callback(hObject, eventData, handles)
wells = handles.arrays;

[i,j] = findCallingWell(hObject, wells);
if ~wells(i,j).used
    return
end

if ~isempty(handles.selectedWell)
    iOld  = handles.selectedWell(1);
    jOld  = handles.selectedWell(2);
    if ~wells(iOld, jOld).done
        strColor = 'k';
    else
        strColor = 'g';
    end
    set(wells(iOld, jOld).hPlot, 'color', strColor, 'markerfacecolor', 'w')
    
end
if ~isempty(handles.template)
    set(handles.pbAll, 'enable', 'on');
    set(handles.pbThis, 'enable', 'on');
end

handles.selectedWell = [i,j];

set(wells(i,j).hPlot, 'markerfacecolor', [0.7, 0.3, 1]);
set(handles.stWell, 'String', wells(i,j).id);
guidata(hObject, handles); 

function [i,j] = findCallingWell(hCalling, wells)
[nRows, nCols] = size(wells);
for i=1:nRows
    for j=1:nCols
        if hCalling == wells(i,j).hPlot;
            return
        end
    end
end                
            
function arrays = initializeDataSet(list, instrument)

if isequal(instrument(1:4), 'QC96');
    instrument = 'PS96';
end

if isequal(instrument(1:4), 'FD10');
    instrument = 'PS4_';
end
switch instrument(1:4)
    case 'PS96' 
        wells = ones(12,8);
        strRow = ['ABCDEFGH'];
        strCol = ['01';'02';'03';'04';'05';'06';'07';'08';'09'; '10'; '11'; '12'];
        wList = vGetUniqueID(list, 'W');
        for i=1:length(strRow)
            for j=1:size(strCol,1)
                strID = ['W',strRow(i), strCol(j,:)];
                if ~isempty(strmatch(strID, wList))
                    arrays(i,j).used = 1;
                    arrays(i,j).id = strID;
                    arrays(i,j).done = 0;
                    arrays(i,j).strResultFile = [];
                else
                    arrays(i,j).used = 0;
                    arrays(i,j).done = 0;
                end
            end
        end
    case 'PS4_';
        wells = ones(4,1);
        [nRows, nCols] = size(wells);
        row = [1:4];
        wList = vGetUniqueID(list, 'W');
        for i = 1:nRows
            strID = ['W', num2str(i)];
            if ~isempty(strmatch(strID, wList));
                arrays(i).used = 1;
                arrays(i).id = strID;
                arrays(i).done = 0;
                arrays(i).strResultFile = [];
                

            else
                arrays(i).used = 0;
                arrays(i).done = 0;
                
            end
        end
        
      

    otherwise
        error('unsupported instrument');
end

function arrays = initializeGraph(hAx, arrays)
[nRows, nCols] = size(arrays);

axes(hAx);
hold off
axis([0 13 0 9]);
hold on
for i=1:nRows
    for j=1:nCols
        h(i,j) = plot(hAx, j,nRows + 1 -  i, 'ko', 'markersize', 12);
        arrays(i,j).hPlot = h(i,j);
        if ~arrays(i,j).used
            set(h(i,j), 'marker', 'x')
        end
    end
end
set(h, 'ButtonDownFcn', 'gridManager(''well_Callback'',gcbo,[],guidata(gcbo))');
set(hAx, 'visible', 'on','xtick', [], 'ytick', [], 'box', 'on');




% --------------------------------------------------------------------
function miGridMode_Callback(hObject, eventdata, handles)
% hObject    handle to miGridMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miKinLast_Callback(hObject, eventdata, handles)
% hObject    handle to miKinLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinFirst, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
handles.gridMode = 'kinLast';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miKinFirst_Callback(hObject, eventdata, handles)
% hObject    handle to miKInFirst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
handles.gridMode = 'kinFirst';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miEndPoint_Callback(hObject, eventdata, handles)
% hObject    handle to miEndPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miKinFirst, 'checked', 'off');
set(handles.miAll, 'checked', 'off');
% --------------------------------------------------------------------
function miAll_Callback(hObject, eventdata, handles)
% hObject    handle to miAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'checked', 'on');
set(handles.miKinLast, 'checked', 'off');
set(handles.miEndPoint, 'checked', 'off');
set(handles.miKinFirst, 'checked', 'off');

% --------------------------------------------------------------------
function miLoadTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to miLoadTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curDir = pwd;
if exist(handles.iniPars.templateDir)
    cd(handles.iniPars.templateDir);
end


[fName, pathName] = uigetfile('*.txt', 'Please, select a template file');
cd(curDir);
if fName
    handles.iniPars.templateDir = pathName;
    handles.template = fName;
    handles.oArray = set(handles.oArray, 'mask', [],'xOffset', [],'yOffset', []);
    try
        [handles.oArray, handles.clID] = fromFile(handles.oArray, [pathName, '\', fName], handles.iniPars.gridRefMarker);
    catch
        errordlg(lasterr, 'Error while loading template file');
        return
    end
    if ~isempty(handles.selectedWell)
        set(handles.pbAll, 'enable', 'on');
        set(handles.pbThis, 'enable', 'on');
    end

end

guidata(hObject, handles);



function handles = analyze(hObject, handles);

set(gcf, 'pointer', 'watch');
drawnow



% find selected well entries
% W
currentArray = handles.arrays(handles.selectedWell(1), handles.selectedWell(2));
[wellList{1:length(handles.list)}] = deal(handles.list.W);
iCurrentWell = strmatch(currentArray.id, char(wellList)); 
currentList = handles.list(iCurrentWell);
% F
val =   get(handles.puFilter, 'value');
clFilter =   get(handles.puFilter, 'String');
[filterList{1:length(currentList)}] = deal(currentList.F);
iCurrentFilter = strmatch(clFilter{val}, filterList, 'exact');
currentList = currentList(iCurrentFilter);
% T
val  = get(handles.puIntegrationTime, 'value');
clTime  = get(handles.puIntegrationTime, 'String');
[timeList{1:length(currentList)}] =  deal(currentList.T);
iCurrentTime = strmatch(clTime{val}, timeList, 'exact');
currentList = currentList(iCurrentTime);

nImages = length(currentList);

stString = ['Analyzing ',num2str(nImages), ' images for well ',currentArray.id,'...'];
set(handles.stStatus, 'String', stString);
drawnow
rSize = [handles.iniPars.xResize, handles.iniPars.yResize];

try
    for i=1:nImages
        
        I(:,:,i) = imread([currentList(i).path, '\', currentList(i).name]);
     end
catch
    errordlg(lasterr, currentArray.id);
    return
end
drawnow;

time = clock;
for i = 1:nImages
     pump  = char(currentList(i).P);
     c(i) = str2num(pump(2:end));
     str = fnReplaceExtension([currentList(i).path, '\', currentList(i).name], handles.iniPars.imageResultsExtension);
     expNames(i) = cellstr(str); 
end
[c, iSort] = sort(c);
I = I(:,:,iSort);
expNames = expNames(iSort);
try
    handles = gridCycleSeries(handles, I);
catch
     errordlg(lasterr, ['Error while analyzing: ',currentArray.id]);
     return
end
currentArray.done = 1;
handles.arrays(handles.selectedWell(1), handles.selectedWell(2)) = currentArray;

strTime = num2str(etime(clock, time));
%disp([currentArray.id, ':', strTime]);
stString = ['Ready (',strTime,'s)'];
set(handles.stStatus, 'String', stString);
set(gcf, 'pointer', 'arrow');
if handles.bShow
     hp = showInteractive(handles.qImage, I);
     set(hp, 'name', currentArray.id);
     drawnow
end

% Export
strBase = [currentList(i).W, '_', currentList(i).F, '_', currentList(i).T];
resBase = [handles.iniPars.dataDir,'\', handles.iniPars.resDir, '\', strBase];
handles.resBase = resBase;
handles.expNames = expNames;
handles.expMode = 'kinetics';
handles.cAxis = c;

% --------------------------------------------------------------------
function miUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to miUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'checked'), 'on')
    set(hObject, 'checked', 'off');
else
    set(hObject, 'checked', 'on');
end



function exportWell(imNames, aggrName, aggrMode, aggrAxis, oQ, bImages, bSeries)
    
    try
        if bImages
            export(oQ, 'images', imNames);
        end
        if bSeries
            export(oQ, aggrMode, aggrName,aggrAxis);
        end
    catch
        errordlg(lasterr, 'Error while exporting data');
    end
% --------------------------------------------------------------------
function miExport_Callback(hObject, eventdata, handles)
% hObject    handle to miExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miExportImages_Callback(hObject, eventdata, handles)
% hObject    handle to miExportImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'checked'), 'on')
    set(hObject, 'checked', 'off');
else
    set(hObject, 'checked', 'on');
end

% --------------------------------------------------------------------
function miExportQuantified_Callback(hObject, eventdata, handles)
% hObject    handle to miExportQuantified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'checked'), 'on')
    set(hObject, 'checked', 'off');
else
    set(hObject, 'checked', 'on');
end



% --------------------------------------------------------------------
function miPreprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to miPreprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function miPreprocessingNone_Callback(hObject, eventdata, handles)
% hObject    handle to miPreprocessingNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Checked', 'on');
handles.prepMode = 'none';
set(handles.miPreProcessingFast, 'checked', 'off');
set(handles.miPreprocessingSlow, 'checked', 'off');
guidata(hObject, handles);

% --------------------------------------------------------------------
function miPreProcessingFast_Callback(hObject, eventdata, handles)
% hObject    handle to miPreProcessingFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Checked', 'on');
handles.prepMode = 'fast';
set(handles.miPreprocessingNone, 'checked', 'off');
set(handles.miPreprocessingSlow, 'checked', 'off');
guidata(hObject, handles);
% --------------------------------------------------------------------
function miPreprocessingSlow_Callback(hObject, eventdata, handles)
% hObject    handle to miPreprocessingSlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Checked', 'on');
handles.prepMode = 'slow';
set(handles.miPreprocessingNone, 'checked', 'off');
set(handles.miPreProcessingFast, 'checked', 'off');
guidata(hObject, handles);
% --- Executes on selection change in puIntegrationTime.
function puIntegrationTime_Callback(hObject, eventdata, handles)
% hObject    handle to puIntegrationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puIntegrationTime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puIntegrationTime


% --- Executes during object creation, after setting all properties.
function puIntegrationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puIntegrationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in puFilter.
function puFilter_Callback(hObject, eventdata, handles)
% hObject    handle to puFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns puFilter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from puFilter


% --- Executes during object creation, after setting all properties.
function puFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function miLoadImages_Callback(hObject, eventdata, handles)
% hObject    handle to miLoadImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[sFiles, sPath] = uigetfile([handles.iniPars.imagesDir,'\*.*'], 'multiselect', 'on');
if ~isequal(sFiles, 0)
    handles.iniPars.imagesDir = sPath;
end
guidata(hObject, handles);
       


% --------------------------------------------------------------------
function miFilter_Callback(hObject, eventdata, handles)
% hObject    handle to miFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = inputdlg('edit here: ', 'Filter', 1, cellstr(handles.iniPars.dataSearchFilter));
if ~isempty(a)
    handles.iniPars.dataSearchFilter = char(a);
    guidata(hObject, handles);
    strLabel = ['Edit Search Filter (',handles.iniPars.dataSearchFilter,')']; 
    set(hObject, 'Label', strLabel);
end






% --------------------------------------------------------------------
function miSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to miSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miFixedSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to miFixedSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miAdaptSegmentation, 'checked', 'off')
handles.seriesMode = 'fixed';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miAdaptSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to miAdaptSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on');
set(handles.miFixedSegmentation, 'checked', 'off')
handles.seriesMode = 'adapt';
guidata(hObject, handles);


% --------------------------------------------------------------------
function miSpotWeight_Callback(hObject, eventdata, handles)
% hObject    handle to miSpotWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function miSpotWeightIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to miSpotWeightIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on')
set(handles.miSpotWeightEqual, 'checked', 'off');
handles.spotWeight = 'linear';
guidata(hObject, handles);
% --------------------------------------------------------------------
function miSpotWeightEqual_Callback(hObject, eventdata, handles)
% hObject    handle to miSpotWeightEqual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'checked', 'on')
set(handles.miSpotWeightIntensity, 'checked', 'off');
handles.spotWeight = 'equalize';
guidata(hObject, handles);


% --------------------------------------------------------------------
function miExportCurrent_Callback(hObject, eventdata, handles)
% hObject    handle to miExportCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf, 'pointer', 'watch');
drawnow;

if isequal(get(handles.miExportImages, 'checked'), 'on')
    bImages = 1;
else
    bImages = 0;
end
if isequal(get(handles.miExportQuantified, 'checked'), 'on')
    bQuant = 1;
else
    bQuant = 0;
end

if ~bQuant & ~bImages
    errordlg('No Export Options switched on: saved nothing!', 'Export Current');
end

    
exportWell(handles.expNames, handles.resBase, handles.expMode, handles.cAxis, handles.qImage, bImages, bQuant);

set(gcf, 'pointer', 'arrow');
drawnow;


% --------------------------------------------------------------------
function miSegMethod_Callback(hObject, eventdata, handles)
% hObject    handle to miSegMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function miSegmentationEdge_Callback(hObject, eventdata, handles)
% hObject    handle to miSegmentationEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'checked', 'on');
set(handles.miSegmentationThreshold, 'checked', 'off');
handles.segmentationMethod = 'Edge';
guidata(hObject, handles);

% --------------------------------------------------------------------
function miSegmentationThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to miSegmentationThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'checked', 'on');
set(handles.miSegmentationEdge, 'checked', 'off');
handles.segmentationMethod = 'Threshold';
guidata(hObject, handles);





% --------------------------------------------------------------------
function miParEdit_Callback(hObject, eventdata, handles)
% hObject    handle to miParEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try 
    
    dos(['notepad ',handles.iniFile]);
catch
    errordlg(lasterr, 'Could not open parameter file');
    return
end
handles.iniPars = getparsfromfile(handles.iniFile, handles.iniPars);
guidata(hObject, handles);

% --------------------------------------------------------------------
function miParameters_Callback(hObject, eventdata, handles)
% hObject    handle to miParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


