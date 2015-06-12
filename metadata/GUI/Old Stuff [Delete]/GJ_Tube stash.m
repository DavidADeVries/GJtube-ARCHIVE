function varargout = GJ_Tube(varargin)

% add needed librarys

addpath('../Image Processing');
addpath('../CircStat2012a');
addpath('../arrow');

% GJ_TUBE MATLAB code for GJ_Tube.fig
%      GJ_TUBE, by itself, creates a new GJ_TUBE or raises the existing
%      singleton*.
%
%      H = GJ_TUBE returns the handle to a new GJ_TUBE or the handle to
%      the existing singleton*.
%
%      GJ_TUBE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GJ_TUBE.M with the given input arguments.
%
%      GJ_TUBE('Property','Value',...) creates a new GJ_TUBE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GJ_Tube_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GJ_Tube_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GJ_Tube

% Last Modified by GUIDE v2.5 04-Jun-2015 14:56:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GJ_Tube_OpeningFcn, ...
    'gui_OutputFcn',  @GJ_Tube_OutputFcn, ...
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


% --- Executes just before GJ_Tube is made visible.
function GJ_Tube_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GJ_Tube (see VARARGIN)

% Choose default command line output for GJ_Tube
handles.output = hObject;

handles.numPatients = 0; %records the number of images that are currently open
handles.currentPatientNum = 0; %the current image being displayed
handles.updateUndoCache = false; %tells upclick listener whether or not to save undo data

handles.patients = Patient.empty;

axes(handles.imageDisplay);
imshow([],[]);
cla(handles.imageDisplay); % clear axes
disableAllToggles(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GJ_Tube wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GJ_Tube_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[imageFilename, imagePath, ~] = uigetfile({'*.dcm;*.mat','Valid Files (*.dcm;*.mat)';'*.dcm','DICOM Files (*.dcm)';'*.mat','Patient Analysis Files (*.mat)'},'Select Image','/data/projects/GJtube/rawdata/');

if imageFilename ~= 0 %user didn't click cancel!
    len = length(imageFilename);
    fileType = imageFilename(len-2:len);
    
    completeFilepath = strcat(imagePath, imageFilename);
    
    openCancelled = false;
    
    if strcmp(fileType, 'dcm') %dicom file!
        % TODO: validate dicom file??
        
        dicomImage = dicomread(completeFilepath);
        dicomInfo = dicominfo(completeFilepath);
        originalLimits = [min(min(dicomImage)), max(max(dicomImage))];
        
        newFile = File(dicomInfo, dicomImage, originalLimits);
        
        [patientNum, patient] = findPatient(handles.patients, dicomInfo.PatientID);
        
        if isempty(patient)
            handles.numPatients = handles.numPatients + 1;
            handles.currentPatientNum = handles.numPatients;
            patient = Patient(dicomInfo.PatientID);
        else
            handles.currentPatientNum = patientNum;
        end
        
        patient = patient.addFile(newFile);
        
    else % load previous analysis file .mat
        loadedData = load(completeFilepath);
        
        patient = loadedData.patient;
        
        [patientNum, ~] = findPatient(handles.patients, patient.patientId);
        
        if patientNum == 0 % create new
            handles.numPatients = handles.numPatients + 1;
            handles.currentPatientNum = handles.numPatients;            
        else %overwrite whatever patient with the same id was there before
            question = 'The patient you are currently opening is already open in your workspace. Continuing will discard any unsaved changes of this patient. Do you wish to continue?';
            
            go = 'OK';
            noGo = 'Cancel';
            
            choice = questdlg(question, 'Patient Conflict', go, noGo, go);
            
            if strcmp(choice, go)            
                handles.currentPatientNum = patientNum;
            else
                openCancelled = true;
            end                
        end
        
        if ~openCancelled
            newFile = patient.getCurrentFile(); %not really 'new' but you get the idea
        end
    end     
    
    if ~openCancelled
        handles.patients(handles.currentPatientNum) = patient;
        
        updateImageInfo(newFile, handles);
        updatePatientSelector(handles);
        
        [plotHandles, waypoints] = showCurrentImage(newFile, handles.imageDisplay);
        
        newFile.waypoints = waypoints;
        
        newFile = updateUndoCache(newFile);
        
        handles.plotHandles = plotHandles;
        
        % push up changes
        
        handles = pushUpChanges(handles, newFile);
        
        guidata(hObject, handles);
        
        metricPointHandles = showCurrentMetricPoints(newFile, handles.imageDisplay);
        midlineHandle = showCurrentMidline(newFile, handles.imageDisplay);
        refLineHandle = showCurrentRefLine(newFile, handles.imageDisplay);
        quickMeasureHandle = showCurrentQuickMeasure(newFile, handles.imageDisplay);
        
        imageHandle = plotHandles.imageHandle;
        
        createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);
        
        updateToggleButtons(newFile, handles);
    end
    
end

function interpolConstrain_Callback(hObject, eventdata, handles)
% hObject    handle to interpolConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interpolConstrain as text
%        str2double(get(hObject,'String')) returns contents of interpolConstrain as a double


% --- Executes during object creation, after setting all properties.
function interpolConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interpolConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function priorConstrain_Callback(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of priorConstrain as text
%        str2double(get(hObject,'String')) returns contents of priorConstrain as a double


% --- Executes during object creation, after setting all properties.
function priorConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curveConstrain_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to curveConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curveConstrain as text
%        str2double(get(hObject,'String')) returns contents of curveConstrain as a double


% --- Executes during object creation, after setting all properties.
function curveConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curveConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchAngle_Callback(hObject, eventdata, handles)
% hObject    handle to searchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchAngle as text
%        str2double(get(hObject,'String')) returns contents of searchAngle as a double


% --- Executes during object creation, after setting all properties.
function searchAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function angularRes_Callback(hObject, eventdata, handles)
% hObject    handle to angularRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angularRes as text
%        str2double(get(hObject,'String')) returns contents of angularRes as a double


% --- Executes during object creation, after setting all properties.
function angularRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angularRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in unitPanel.
function unitPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitPanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

newValue = get(eventdata.NewValue, 'Tag');

currentFile = getCurrentFile(handles);

switch newValue
    case 'unitNone'
        currentFile.displayUnits = 'none';
    case 'unitRelative'
        currentFile.displayUnits = 'relative';
    case 'unitAbsolute'
        currentFile.displayUnits = 'absolute';
    case 'unitPixel'
        currentFile.displayUnits = 'pixel';
    otherwise
        currentFile.displayUnits = 'none';
end

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.updateUndoCache
    
    currentFile = getCurrentFile(handles);
    
    currentFile = updateUndoCache(currentFile);
    
    handles = pushUpChanges(handles, currentFile);

    handles.updateUndoCache = false;
    
    guidata(hObject, handles);
end


% --- Executes on button press in resegmentTube.
function resegmentTube_Callback(hObject, eventdata, handles)
% hObject    handle to resegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.waypoints = updatePositionsOfWaypoints(currentFile);

newWaypoints = getNewWaypoints(currentFile);

currentFile.waypoints = newWaypoints;

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

segmentTube_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function selectContrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

if currentFile.roiOn % the MATLAB contrast interface when the image isn't using enough of the range, so for ROI we max it out
    roiImage = imcrop(currentFile.image, currentFile.roiCoords);
    
    cLim = [min(min(roiImage)), max(max(roiImage))];
    
    set(handles.imageDisplay,'CLim',cLim);
end

uiwait(imcontrast(handles.imageDisplay));

currentFile.contrastLimits = get(handles.imageDisplay, 'CLim');
currentFile.contrastOn = true;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function toggleContrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.contrastOn = ~currentFile.contrastOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function toggleRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);
    
currentFile.roiOn = ~currentFile.roiOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function toggleWaypoints_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.waypointsOn = ~currentFile.waypointsOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function toggleTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.tubeOn = ~currentFile.tubeOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function toggleReference_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.refOn = ~currentFile.refOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function toggleMidline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.midlineOn = ~currentFile.midlineOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function toggleMetrics_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.metricsOn = ~currentFile.metricsOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay);
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.quickMeasureOn = ~currentFile.quickMeasureOn;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function selectRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

[xmin,ymin,width,height] = findRoi(currentFile.image);

currentFile.roiOn = false;
showCurrentImage(currentFile, handles.imageDisplay);

cropWindow = imrect(handles.imageDisplay, [xmin,ymin,width,height]);
cropCoords = wait(cropWindow);

currentFile.roiCoords = cropCoords;
currentFile.roiOn = true;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

currentFile = updateUndoCache(currentFile);

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function selectWaypoints_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.waypointsOn = false; % need to clear the old ones off just in case

showCurrentImage(currentFile, handles.imageDisplay);

[x,y] = getptsCustom(handles.imageDisplay, 'c'); %rip off of MATLAB fn, just needed to change the markers

numPoints = length(x);

waypoints = Waypoint.empty(numPoints,0);

for i=1:numPoints
    waypoints(i) = Waypoint([x(i),y(i)],currentFile.roiOn, currentFile.roiCoords);
end

currentFile.waypoints = waypoints;
currentFile.waypointsOn = true;

currentFile.tubePoints = [];
currentFile.tubeOn = false;
currentFile.metricPoints = [];
currentFile.metricsOn = false;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function segmentTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to segmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

handles.updateUndoCache = true;

image = getAdjustedImage(currentFile);

interpolConstrain = str2double(get(handles.interpolConstrain, 'String'));
priorConstrain = str2double(get(handles.priorConstrain, 'String'));
curveConstrain = str2double(get(handles.curveConstrain, 'String'));
radius = str2double(get(handles.radius, 'String'));
searchAngle = str2double(get(handles.searchAngle, 'String'));
width = str2double(get(handles.width, 'String'));
angularRes = str2double(get(handles.angularRes, 'String'));

waypoints = currentFile.getWaypointPoints;

if currentFile.roiOn
    waypoints = nonRoiToRoi(currentFile.roiCoords, waypoints);
end

[tubePoints, waypointPassbys] = pathFinder(image, waypoints, interpolConstrain, priorConstrain, curveConstrain, radius, searchAngle, width, angularRes);

currentFile.tubeOn = true;

currentFile.metricPoints = [];
currentFile.metricsOn = false;

if currentFile.roiOn
    currentFile.tubePoints = roiToNonRoi(currentFile.roiCoords, tubePoints);
    currentFile.waypointPassbys = roiToNonRoi(currentFile.roiCoords, waypointPassbys);
else
    currentFile.tubePoints = tubePoints;
    currentFile.waypointPassbys = waypointPassbys;
end

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function tuneTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tuneTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

[tuningPoints] = plotTuningPoints(currentFile, handles.imageDisplay);

draggable = true;

[waypoints] = updateWaypoints(currentFile.waypoints, handles.imageDisplay, draggable, currentFile.roiOn, currentFile.roiCoords);

currentFile.tuningPoints = tuningPoints;
currentFile.waypoints = waypoints;

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

% --------------------------------------------------------------------
function selectReference_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lineHandle = imline(handles.imageDisplay);

refPoints = lineHandle.getPosition;

currentFile = getCurrentFile(handles);

if currentFile.roiOn
    refPoints = roiToNonRoi(currentFile.roiCoords, refPoints);
end

currentFile.refPoints = refPoints;
currentFile.refOn = true;

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function selectMidline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lineHandle = imline(handles.imageDisplay);

midlinePoints = lineHandle.getPosition;

currentFile = getCurrentFile(handles);

if currentFile.roiOn
    midlinePoints = roiToNonRoi(currentFile.roiCoords, midlinePoints);
end

currentFile.midlinePoints = midlinePoints;
currentFile.midlineOn = true;
currentFile.metricPoints = [];
currentFile.metricsOn = false;

updateDisplayAndHandles(currentFile, handles, hObject);

% --------------------------------------------------------------------
function calcMetrics_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to calcMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

corAngle = findCorrectionAngle(currentFile.midlinePoints);

rotMatrix = [cosd(corAngle) -sind(corAngle); sind(corAngle) cosd(corAngle)];

%rotate tube points into coord system where midline is vertical
corTubePoints = applyRotationMatrix(currentFile.tubePoints, rotMatrix);

[maxL, min, maxR] = findMetricsPoints(corTubePoints);

invRotMatrix = [cosd(-corAngle) -sind(-corAngle); sind(-corAngle) cosd(-corAngle)];

%rotate back into original coord system
maxL = applyRotationMatrix(maxL, invRotMatrix);
min = applyRotationMatrix(min, invRotMatrix);
maxR = applyRotationMatrix(maxR, invRotMatrix);

currentFile.metricPoints = [maxL; min; maxR];
currentFile.metricsOn = true;

% putting it in the reference units is preferred, but if not, pixels it is
% boys, pixels it is
if isempty(currentFile.refPoints)
    currentFile.displayUnits = 'absolute';
else
    currentFile.displayUnits = 'relative';
end

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);

currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay);
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function quickMeasure_ClickedCallback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to quickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lineHandle = imline(handles.imageDisplay);

quickMeasurePoints = lineHandle.getPosition;

currentFile = getCurrentFile(handles);

if currentFile.roiOn
    quickMeasurePoints = roiToNonRoi(currentFile.roiCoords, quickMeasurePoints);
end

currentFile.quickMeasurePoints = quickMeasurePoints;
currentFile.quickMeasureOn = true;

% putting it in the reference units is preferred, but if not, pixels it is
% boys, pixels it is
if isempty(currentFile.refPoints)
    currentFile.displayUnits = 'absolute';
else
    currentFile.displayUnits = 'relative';
end

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

currentFile = updateUndoCache(currentFile);

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay);
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function undo_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performUndo(currentFile);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function redo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performRedo(currentFile);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function earlierImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.currentFileNum - 1;

if newFileNum < 1
    newFileNum = 1;
end

currentPatient.currentFileNum = newFileNum;

handles = pushUpPatientChanges(handles, currentPatient);

currentFile = getCurrentFile(handles);

updateImageInfo(currentFile, handles);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function laterImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to laterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.currentFileNum + 1;

numFiles = currentPatient.getNumFiles();

if newFileNum > numFiles
    newFileNum = numFiles;
end

currentPatient.currentFileNum = newFileNum;

handles = pushUpPatientChanges(handles, currentPatient);

currentFile = getCurrentFile(handles);

updateImageInfo(currentFile, handles);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);


% --------------------------------------------------------------------
function longitudinalView_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to longitudinalView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

longitudinalFileNumbers = getLongitudinalFiles(currentPatient.files);

[listboxLabels, listboxValues] = getLongitudinalListboxDate(currentPatient.files, longitudinalFileNumbers);

set(handles.longitudinalListbox, 'String', listboxLabels, 'Value', listboxValues);

currentFile = currentPatient.getCurrentFile();

baseRefPoints = currentFile.refPoints;

for i=1:length(longitudinalFileNumbers)
    file = currentPatient.files(longitudinalFileNumbers(i));
    
    [shift, scale, angleShift, angle] = getTransformParams(baseRefPoints, file.refPoints);
    
    transform = getTransform(shift, scale, angleShift, angle);
    
    [x,y] = transformPointsForward(transform, file.tubePoints(:,1), file.tubePoints(:,2));
    
    transformTubePoints = [x,y];
    
    if currentFile.roiOn
        transformTubePoints = nonRoiToRoi(currentFile.roiCoords, transformTubePoints);
    end
    
    plotTubePoints(transformTubePoints, 'line', handles.imageDisplay);
end


% --- Executes on selection change in longitudinalListbox.
function longitudinalListbox_Callback(hObject, eventdata, handles)
% hObject    handle to longitudinalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns longitudinalListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from longitudinalListbox


% --- Executes during object creation, after setting all properties.
function longitudinalListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longitudinalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function earliestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = 1;

currentPatient.currentFileNum = newFileNum;

handles = pushUpPatientChanges(handles, currentPatient);

currentFile = getCurrentFile(handles);

updateImageInfo(currentFile, handles);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --------------------------------------------------------------------
function latestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to latestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

newFileNum = currentPatient.getNumFiles();

currentPatient.currentFileNum = newFileNum;

handles = pushUpPatientChanges(handles, currentPatient);

currentFile = getCurrentFile(handles);

updateImageInfo(currentFile, handles);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);

% --- Executes on selection change in patientSelector.
function patientSelector_Callback(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patientSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patientSelector

handles.currentPatientNum = get(hObject,'Value');

updatePatientSelector(handles);

currentFile = getCurrentFile(handles);

[plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
currentFile.waypoints = waypoints;

handles.plotHandles = plotHandles;

% push up changes

handles = pushUpChanges(handles, currentFile);

guidata(hObject, handles);

metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay); 
quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);

imageHandle = plotHandles.imageHandle;

createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);

updateToggleButtons(currentFile, handles);



% --- Executes during object creation, after setting all properties.
function patientSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function savePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

patient = savePatient(currentPatient);

handles = pushUpPatientChanges(handles, patient, false);    

guidata(hObject, handles);


% --------------------------------------------------------------------
function saveAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:handles.numPatients
    patient = savePatient(handles.patients(i));
        
    handles = pushUpPatientChanges(handles, patient, false, i);    
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

saveFirst = currentPatient.changesPending;

closeCancelled = false;

if saveFirst
    question = 'Do wish to save unsaved changes before closing?';
    
    go = 'Save';
    noGo = 'Discard';
    cancel = 'Cancel';
    
    choice = questdlg(question, 'Unsaved Changes', go, noGo, cancel, go);
    
    if strcmp(choice, noGo)
        saveFirst = false;
    elseif strcmp(choice, cancel)
        closeCancelled = true;
    end
end

if ~closeCancelled
    if saveFirst
        savePatient(currentPatient);
    end
    
    newPatients = Patient.empty(handles.numPatients-1,0);
    
    newCounter = 1;
    
    patientNum = handles.currentPatientNum;
    
    for i=1:handles.numPatients
        if i ~= patientNum
            newPatients(newCounter) = handles.patients(i); %shift all down to fill gap
            
            newCounter = newCounter + 1;
        end
    end
    
    handles.patients = newPatients;
    
    handles.numPatients = handles.numPatients - 1; %reduce the number of patients
    
    if handles.currentPatientNum > handles.numPatients
        handles.currentPatientNum = handles.numPatients;
    end
    
    if handles.numPatients == 0
        cla(handles.imageDisplay);
        set(handles.patientSelector, 'String', {'No Patient Selected'}, 'Value', 1);
        disableAllToggles(handles);
        
        guidata(hObject, handles);
    else
        updatePatientSelector(handles);
        
        currentFile = getCurrentFile(handles);
        
        [plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
        
        currentFile.waypoints = waypoints;
        
        handles.plotHandles = plotHandles;
        
        % push up changes
        
        handles = pushUpChanges(handles, currentFile);
        
        guidata(hObject, handles);
        
        metricPointHandles = showCurrentMetricPoints(currentFile, handles.imageDisplay);
        midlineHandle = showCurrentMidline(currentFile, handles.imageDisplay);
        refLineHandle = showCurrentRefLine(currentFile, handles.imageDisplay);
        quickMeasureHandle = showCurrentQuickMeasure(currentFile, handles.imageDisplay);
        
        imageHandle = plotHandles.imageHandle;
        
        createCallbacks(metricPointHandles, midlineHandle, refLineHandle, quickMeasureHandle, imageHandle, hObject);
        
        updateToggleButtons(currentFile, handles);
    end
end
    
    


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSavePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savePatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveAll_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.savePath = ''; %clear it so that it will be redefined

patient = savePatient(currentPatient);

handles = pushUpPatientChanges(handles, patient, false);    

guidata(hObject, handles);

% --------------------------------------------------------------------
function menuSelectContrast_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectContrast_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSegmentTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuSegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

segmentTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuTuneTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuTuneTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tuneTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectReference_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectReference_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuCalcMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to menuCalcMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

calcMetrics_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

quickMeasure_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuUndo_Callback(hObject, eventdata, handles)
% hObject    handle to menuUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

undo_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRedo_Callback(hObject, eventdata, handles)
% hObject    handle to menuRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

redo_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuSelectMidline_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectMidline_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuSelectWaypoints_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectWaypoints_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuClosePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuClosePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closePatient_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to menuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuTools_Callback(hObject, eventdata, handles)
% hObject    handle to menuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuView_Callback(hObject, eventdata, handles)
% hObject    handle to menuView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuToggleContrast_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleContrast_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleWaypoints_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleWaypoints_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleReference_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleReference_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleMidline_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleMidline_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleMetrics_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles);


