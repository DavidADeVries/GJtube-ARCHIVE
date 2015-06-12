function [  ] = updateDisplayAndHandles( currentFile, handles, hObject, varargin )
%updateDisplayAndHandles saves changes to the currentFile and pushes them
%up to the guidata as well updates the image view and creates the necessary
%callbacks and all that jazz.
%by default, the undo cache is updated, though this can be disabled by
%passing an optional fourth boolean parameter, updateUndo

if isempty(currentFile);
    cla(handles.imageDisplay); %clear imageDisplay axes
    disableAllToggles(handles);
    
    updateImageInfo( currentFile, handles)
    
    %just turn on open functionality
    set(handles.open, 'Enable', 'on');
    set(handles.menuOpen, 'Enable', 'on');
    %keep patient selector up, as well as closing patient, etc.
    set(handles.patientSelector, 'Enable', 'on');
    
    set(handles.savePatient, 'Enable', 'on');
    set(handles.saveAll, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    
    set(handles.menuSavePatient, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'off');
    set(handles.menuClosePatient, 'Enable', 'on');
    
    
    guidata(hObject, handles);
else

    updateUndo = true; %default
    
    if length(varargin) == 1
        updateUndo = varargin{1};
    end
    
    [plotHandles, waypoints] = showCurrentImage(currentFile, handles.imageDisplay);
    
    currentFile.waypoints = waypoints;
    
    handles.plotHandles = plotHandles;
    
    if updateUndo
        currentFile = updateUndoCache(currentFile);
    end
    
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

