function varargout = overview(varargin)
% OVERVIEW M-file for overview.fig
%      OVERVIEW, by itself, creates a new OVERVIEW or raises the existing
%      singleton*.
%
%      H = OVERVIEW returns the handle to a new OVERVIEW or the handle to
%      the existing singleton*.
%
%      OVERVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OVERVIEW.M with the given input arguments.
%
%      OVERVIEW('Property','Value',...) creates a new OVERVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before overview_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to overview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help overview

% Last Modified by GUIDE v2.5 06-Dec-2004 09:51:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @overview_OpeningFcn, ...
                   'gui_OutputFcn',  @overview_OutputFcn, ...
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


% --- Executes just before overview is made visible.
function overview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to overview (see VARARGIN)

% Choose default command line output for overview
IniPars.initialDir = 'C:\';
IniPars.resReduction = 2;
IniPars.showOverviews = 1;
IniPars.pixOffset = 3;
IniPars.evolveFilter = 'W*.tif';
IniPars.pimoptsFilter = '*.tif';
IniPars.filter = 'W*.tif*';
IniPars.instrument = 'PS96';
IniPars.mxScale = 0.1;
IniPars = getparsfromfile('overview.ini', IniPars);

if isequal(IniPars.instrument, 'PS96')
    IniPars.filter = IniPars.evolveFilter;
    set(handles.cbGrid, 'Enable', 'on');
elseif isequal(IniPars.instrument, 'production')
    set(handles.cbGrid, 'Enable', 'off');
    IniPars.filter = IniPars.pimoptsFilter;
end



set(findobj('Tag', 'axImage'), 'visible', 'off');
set(findobj('Tag', 'txStatus'), 'String', 'Ready ...');
set(findobj('Tag', 'pbNext'), 'enable', 'off');
set(findobj('Tag', 'pbPrevious'), 'enable', 'off');
set(findobj('Tag', 'pbAoi'), 'Enable', 'off');
set(findobj('Tag', 'pbGo'), 'Enable', 'off');
set(findobj('Tag', 'lbCycles'), 'Enable', 'off');

handles.output = hObject;
handles.IniPars = IniPars;
handles.imFig = 99;
handles.iCycleMatch = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes overview wait for user response (see UIRESUME)
% uiwait(handles.figure1);





function overviewClose(hObject, eventdata, handles)
    SetIniPars('overview.ini', handles.IniPars);
    closereq;
    

% --- Outputs from this function are returned to the command line.
function varargout = overview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbData.
function pbData_Callback(hObject, eventdata, handles)
% hObject    handle to pbData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dDir = uigetdir(handles.IniPars.initialDir, 'Select Data Directory: ');
drawnow;
if ischar(dDir)
    set(gcf, 'Pointer', 'Watch');
    set(hObject, 'Enable', 'off');
    set(findobj('Tag','txStatus'),'String', 'Searching Data ...'); 
    drawnow;
    handles.IniPars.initialDir = dDir;
    
    if isequal(handles.IniPars.instrument, 'PS96')
        fList = setDataPS96(dDir, handles.IniPars.filter);
    elseif isequal(handles.IniPars.instrument, 'production');
        fList = setDataPimOpts(dDir, handles.IniPars.filter);     
        % cyclematch is nou use here so set it for all indices in the list:
        handles.cycleMatch      = [1:length(fList)];
        handles.iCycleMatch     = 1;
    
    else
        uiwait(errordlg(['Undefined instrument: ',handles.IniPars.instrument]));
    end  
        
    if ~isempty(fList)
        info = imfinfo(fList(1).imagePath);
        handles.iMinY    = 1;
        handles.iMinX    = 1;
        handles.iMaxY    = info.Width;
        handles.iMaxX    = info.Height;
        handles.fList    = fList;
    else
        uiwait(errordlg(['No ',handles.IniPars.instrument,' data found in: ',dDir]));
    end
end

set(hObject, 'Enable', 'on');
set(gcf, 'Pointer', 'Arrow');
guidata(hObject, handles);


function fList = setDataPS96(dDir, filter)
 
d = dir(dDir);
iImageResults = 0;
for i=1:length(d)
    if (d(i).isdir)
        iMatch = findstr(d(i).name, 'ImageResults');
        if ~isempty(iMatch)
            iImageResults = i;
        end
    end
end

if iImageResults ~= 0
    srchDir     =   [dDir, '\', d(iImageResults).name];
    srchList   =   filehound2(srchDir, filter);
    fList = sortData(srchList);
    nFound = length(fList);
    set(findobj('Tag', 'txStatus'), 'String', ['Found: ',num2str(nFound), ' Images in: ',srchDir]);
    drawnow
    clUniquePumpCycles = vGetUniqueID(fList, 'strPumpCycle');
    clUniquePumCycles = sort(clUniquePumpCycles);

    set(findobj('Tag', 'lbCycles'), 'String', clUniquePumpCycles, 'Value', length(clUniquePumpCycles), 'Enable', 'on');

else
    fList = [];
    uiwait(errordlg('No ImageResults found!', ''));
end
    
function fList = setDataPimOpts(dDir, filter)
fFound = filehound2(dDir, filter, 0);
nMatch = 0;
fList = [];
for i=1:length(fFound);

    iDash = findstr(fFound(i).fName, '_');
    iDash = iDash(length(iDash));
    iCol = str2num(fFound(i).fName(iDash-2:iDash-1));
    iRow = str2num(fFound(i).fName(iDash+1:iDash+2));
    if ~(isempty(iRow) | isempty(iCol) | iRow > 11 | iRow < 0 | iCol < 0 |iCol > 7)
        nMatch = nMatch + 1;
        fList(nMatch).imagePath = [fFound(i).fPath, '\', fFound(i).fName];
        fList(nMatch).mwCol     = iCol + 1;
        fList(nMatch).mwRow     = iRow + 1;
        fList(nMatch).strArray = fFound(i).fName(iDash-2:iDash+2);
    end
end
nFound = length(fList);
set(findobj('Tag', 'txStatus'),'String', ['Found ',num2str(nFound), ' Images in: ', dDir]);
if nFound
    set(findobj('Tag', 'pbNext'), 'enable', 'on');
    set(findobj('Tag','pbPrevious'), 'enable', 'on');
    set(findobj('Tag','pbAoi'), 'enable', 'on');
    set(findobj('Tag','pbGo'), 'enable', 'on');
else
    set(findobj('Tag', 'pbNext'), 'enable', 'off');
    set(findobj('Tag','pbPrevious'), 'enable', 'off');
    set(findobj('Tag','pbAoi'), 'enable', 'off');
    set(findobj('Tag','pbGo'), 'enable', 'off');
end

function sortedList = sortData(srchList);

    sortedList = struct([]);
    nSorted = 0;
    for i=1:length(srchList)
        [strArray, strFilter, strExpTime, strPumpCycle] = imgReadWFTP(srchList(i).fName, [], 'PS96');
        if ~isempty(strArray)
            nSorted = nSorted + 1;
            sortedList(nSorted).strArray = char(strArray);
            sortedList(nSorted).strPumpCycle = char(strPumpCycle);
            sortedList(nSorted).imagePath = [srchList(i).fPath,'\',srchList(i).fName];
            [mwRow, mwCol] = fname2rc(srchList(i).fName, 'PS96');
            sortedList(nSorted).mwRow = mwRow;
            sortedList(nSorted).mwCol = mwCol;
            
        end
    end
    
    

% --- Executes on selection change in lbCycles.
function lbCycles_Callback(hObject, eventdata, handles)
% hObject    handle to lbCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbCycles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbCycles


val = get(hObject,'Value');
clPump = get(hObject, 'String');
hiVal = max(val);

[pumpList{1:length(handles.fList)}] = deal(handles.fList.strPumpCycle);
iMatch = strmatch(clPump{hiVal}, pumpList);

cFig = gcf;

warning('off', 'Images:initSize:adjustingMag');
imgReadAndDisplay(handles.imFig, handles.fList(iMatch(handles.iCycleMatch)).imagePath, handles.iMinY, handles.iMaxY ...
                    , handles.iMinX, handles.iMaxX, handles.IniPars.instrument);
warning('on', 'Images:initSize:adjustingMag');               
figure(cFig);
handles.cycleMatch = iMatch;

set(handles.pbNext, 'enable', 'on');
set(handles.pbPrevious, 'enable', 'on');
set(handles.pbAoi, 'enable', 'on');
set(handles.pbGo, 'enable', 'on');

guidata(hObject, handles);


function imgReadAndDisplay(hFigure, imgPath, ymin, ymax, xmin, xmax, instrument, mxScale);

if nargin == 7
    mxScale = 0.1;
end

I = imread(imgPath);
I = I(xmin:xmax, ymin:ymax);
figure(hFigure);
lName = length(imgPath);
set(hFigure, 'MenuBar', 'none', 'name', ['...',imgPath(lName-50:lName)]);
set(hFigure, 'Position', [450, 200, 500, 400])
if isequal(instrument, 'production')
    sI = size(I);
    %se = strel('disk', 6); 
    I = I(1:2:sI(1), 1:2:sI(2));
    I = imadjust(I , [0 mxScale],[0 1]);
    %I = rangefilt(I, getnhood(se));
    %I = histeq(I);     
    I = imcomplement(I);
end

hIm =  imshow(I, [], 'initialmagnification', 'fit');

cbVal = get(findobj('Tag', 'cbGrid'), 'Value');
if cbVal == 1
    rsPath = fnReplaceExtension(imgPath, 'txt');
    if exist(rsPath, 'file')
        
        try
            [clHdrs, nSpots] = imgScanFile(rsPath);
            nCols = length(clHdrs);
            clData = imgReadFile(rsPath, nSpots, nCols);
            iX = strmatch('CM-X', clHdrs);
            iY = strmatch('CM-Y', clHdrs);
            iDiam = strmatch('Diameter', clHdrs);
            for j =1 :nSpots
                x = str2num(char(clData(j, iX))) + 1 - ymin;
                y = str2num(char(clData(j, iY))) + 1 - xmin;
                hold on
                h = plot(x, y, 'yo');
                dDiam = char(clData(j, iDiam));
                dDiam = str2num(dDiam);
                set(h, 'LineWidth', 0.3, 'MarkerSize', dDiam/1.7);
         
            end
           
            
       catch
            set(findobj('Tag', 'txStatus'), 'String', 'trouble reading grid ...');
       end
        
    end
end
hold off

% --- Executes during object creation, after setting all properties.
function lbCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbPrevious.
function pbPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to pbPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.iCycleMatch = handles.iCycleMatch - 1;
if handles.iCycleMatch < 1
    handles.iCycleMatch = length(handles.cycleMatch);
end
cFig = gcf;
imgReadAndDisplay(handles.imFig, handles.fList(handles.cycleMatch(handles.iCycleMatch)).imagePath, handles.iMinY, handles.iMaxY ...
                    , handles.iMinX, handles.iMaxX, handles.IniPars.instrument,handles.IniPars.mxScale);
figure(cFig);
guidata(hObject, handles);

% --- Executes on button press in pbNext.
function pbNext_Callback(hObject, eventdata, handles)
% hObject    handle to pbNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iCycleMatch = handles.iCycleMatch + 1;
if handles.iCycleMatch > length(handles.cycleMatch)
    handles.iCycleMatch = 1;
end
cFig = gcf;
imgReadAndDisplay(handles.imFig, handles.fList(handles.cycleMatch(handles.iCycleMatch)).imagePath, handles.iMinY, handles.iMaxY ...
                    , handles.iMinX, handles.iMaxX, handles.IniPars.instrument, handles.IniPars.mxScale);
figure(cFig);
guidata(hObject, handles);




    % --- Executes on button press in pbAoi.
function pbAoi_Callback(hObject, eventdata, handles)
% hObject    handle to pbAoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cFig = gcf;
nCurImage = handles.cycleMatch(handles.iCycleMatch);
figure(handles.imFig);
set(gcf, 'Name', 'Set Aoi');
I = imread(handles.fList(nCurImage).imagePath);
warning('off', 'Images:initSize:adjustingMag');
[iX, iY,gv] = impixel(I, []);
warning('on', 'Images:initSize:adjustingMag');
handles.iMinY = iX(1);
handles.iMaxY = iX(length(iX));
handles.iMinX = iY(1);
handles.iMaxX = iY(length(iY));

imgReadAndDisplay(handles.imFig, handles.fList(nCurImage).imagePath, handles.iMinY, handles.iMaxY ...
                    , handles.iMinX, handles.iMaxX, handles.IniPars.instrument);
figure(cFig);
guidata(hObject, handles);

% --- Executes on button press in pbGo.
function pbGo_Callback(hObject, eventdata, handles)
% hObject    handle to pbGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fList = handles.fList;

if isequal(handles.IniPars.instrument, 'PS96');
       pCycles     = get(handles.lbCycles, 'String');
        val         = get(handles.lbCycles, 'Value');
        pCycles = pCycles(val);
        nOverviews  = length(pCycles);
        [pList{1:nImages}] = deal(fList.strPumpCycle);
elseif isequal(handles.IniPars.instrument, 'production');
        nOverviews = 1;
end

set(handles.txStatus, 'String', ['Creating ',num2str(nOverviews),' overview(s) ...']);
curFig = gcf;
set(gcf, 'Pointer', 'Watch');
drawnow;

nImages = length(handles.fList);

res = handles.IniPars.resReduction;

mkDir(handles.IniPars.initialDir, '_Overviews');
ovDir = [handles.IniPars.initialDir, '\_Overviews'];
for i=1:nOverviews
    if isequal(handles.IniPars.instrument, 'PS96');
          iMatch = strmatch(pCycles{nOverviews - i + 1}, pList);
    elseif isequal(handles.IniPars.instrument, 'production');
          iMatch = [1:length(fList)];
    end
    
    
    for j=1:length(iMatch)
        
        I = imread(fList(iMatch(j)).imagePath);
        I = I(handles.iMinX:res:handles.iMaxX, handles.iMinY:res:handles.iMaxY);
        if isequal(handles.IniPars.instrument, 'production');
            I = imadjust(I, [0 handles.IniPars.mxScale], [0 1]);
            I = imcomplement(I);
        end
        
        sI = size(I);
        iRow = 1 + (fList(iMatch(j)).mwRow - 1) * (sI(1)+handles.IniPars.pixOffset);
        iCol = 1 + (fList(iMatch(j)).mwCol - 1) * (sI(2)+handles.IniPars.pixOffset);
        overviewImage(ceil([iRow:iRow+sI(1)-1]), ceil([iCol:iCol+sI(2)-1])) = I;
    end

    overviewImage = imdivide(overviewImage, 2^16/2^8);
    overviewImage = uint8(overviewImage);

    if i ==1
        maxOv= max(max(overviewImage));
    end


    overviewImage = immultiply(overviewImage, double(255/maxOv));

    figure;
    imshow(overviewImage, [], 'initialmagnification', 'fit');
    
    if isequal(handles.IniPars.instrument, 'PS96')
        ovName = ['overview',pCycles{nOverviews-i+1},'.jpg'];
    elseif isequal(handles.IniPars.instrument, 'production')
        ovName = ['overview.jpg'];
    end
        
    set(gcf, 'Name',ovName)
    imwrite(overviewImage, [ovDir,'\',ovName]);
    drawnow;
    clear overviewImage;
end

uiwait(msgbox(['Overview images have been created in: ', ovDir], 'PS96 Overviews'));
set(handles.txStatus, 'String', 'Ready ...');
figure(curFig);
set(gcf, 'Pointer', 'Arrow');
drawnow;
    
    
% --- Executes on button press in pbCancel.
function pbCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pbCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
overviewClose(hObject, eventdata, handles);






% --- Executes on button press in cbGrid.
function cbGrid_Callback(hObject, eventdata, handles)
% hObject    handle to cbGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbGrid


