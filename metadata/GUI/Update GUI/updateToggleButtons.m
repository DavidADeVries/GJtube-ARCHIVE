function [ ] = updateToggleButtons( file, handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

currentPatient = getCurrentPatient(handles);

if handles.numPatients == 0 %if no patients, only allow opening new files
    disableAllToggles(handles);
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.open, 'Enable', 'on');
elseif isempty(file) %patient open, but no files. Can only perform patient operations
    disableAllToggles(handles);
    
    set(handles.open, 'Enable', 'on');
    set(handles.savePatient, 'Enable', 'on');
    set(handles.saveAll, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatient, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    
    set(handles.patientSelector, 'Enable', 'on');   
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
        set(handles.menuSavePatient, 'Enable', 'off');
    end
else %general toggles that must be turned on if any file is open, regardless of what state its at
    set(handles.patientSelector, 'Enable', 'on');
    
    set(handles.open, 'Enable', 'on');
    set(handles.savePatient, 'Enable', 'on');
    set(handles.saveAll, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    set(handles.removeFile, 'Enable', 'on');
    set(handles.zoomIn, 'Enable', 'on');
    set(handles.zoomOut, 'Enable', 'on');
    set(handles.pan, 'Enable', 'on');
    set(handles.selectContrast, 'Enable', 'on');
    set(handles.selectRoi, 'Enable', 'on');
    set(handles.selectWaypoints, 'Enable', 'on');
    set(handles.selectReference, 'Enable', 'on');
    set(handles.selectMidline, 'Enable', 'on');
    set(handles.quickMeasure, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatient, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    set(handles.menuRemoveFile, 'Enable', 'on');
    %     set(handles.menuzoomIn, 'Enable', 'on');
    %     set(handles.menuzoomOut, 'Enable', 'on');
    %     set(handles.menupan, 'Enable', 'on');
    set(handles.menuSelectContrast, 'Enable', 'on');
    set(handles.menuSelectRoi, 'Enable', 'on');
    set(handles.menuSelectWaypoints, 'Enable', 'on');
    set(handles.menuSelectReference, 'Enable', 'on');
    set(handles.menuSelectMidline, 'Enable', 'on');
    set(handles.menuQuickMeasure, 'Enable', 'on');
    
    
    %contrast toggle button
    if isempty(file.contrastLimits)
        set(handles.toggleContrast, 'Enable', 'off');
        set(handles.menuToggleContrast, 'Enable', 'off');
    else
        set(handles.toggleContrast, 'Enable', 'on');
        set(handles.menuToggleContrast, 'Enable', 'on');
    end
    
    if file.contrastOn
        set(handles.toggleContrast, 'State', 'on');
        set(handles.menuToggleContrast, 'Checked', 'on');
    else
        set(handles.toggleContrast, 'State', 'off');
        set(handles.menuToggleContrast, 'Checked', 'off');
    end
    
    %ROI toggle button
    if isempty(file.roiCoords)
        set(handles.toggleRoi, 'Enable', 'off');
        set(handles.menuToggleRoi, 'Enable', 'off');
    else
        set(handles.toggleRoi, 'Enable', 'on');
        set(handles.menuToggleRoi, 'Enable', 'on');
    end
    
    if file.roiOn
        set(handles.toggleRoi, 'State', 'on');
        set(handles.menuToggleRoi, 'Checked', 'on');
    else
        set(handles.toggleRoi, 'State', 'off');
        set(handles.menuToggleRoi, 'Checked', 'off');
    end
    
    %waypoint toggle button
    if isempty(file.waypoints)
        set(handles.toggleWaypoints, 'Enable', 'off');
        set(handles.menuToggleWaypoints, 'Enable', 'off');
        set(handles.segmentTube, 'Enable', 'off');
        set(handles.menuSegmentTube, 'Enable', 'off');
    else
        set(handles.toggleWaypoints, 'Enable', 'on');
        set(handles.menuToggleWaypoints, 'Enable', 'on');
        set(handles.segmentTube, 'Enable', 'on');
        set(handles.menuSegmentTube, 'Enable', 'on');
    end
    
    if file.waypointsOn
        set(handles.toggleWaypoints, 'State', 'on');
        set(handles.menuToggleWaypoints, 'Checked', 'on');
    else
        set(handles.toggleWaypoints, 'State', 'off');
        set(handles.menuToggleWaypoints, 'Checked', 'off');
    end
    
    %tube toggle button
    if isempty(file.tubePoints)
        set(handles.toggleTube, 'Enable', 'off');
        set(handles.menuToggleTube, 'Enable', 'off');
    else
        set(handles.toggleTube, 'Enable', 'on');
        set(handles.menuToggleTube, 'Enable', 'on');
    end
    
    if file.tubeOn
        set(handles.toggleTube, 'State', 'on');
        set(handles.menuToggleTube, 'Checked', 'on');
    else
        set(handles.toggleTube, 'State', 'off');
        set(handles.menuToggleTube, 'Checked', 'off');
    end
    
    %reference points button
    if isempty(file.refPoints)
        set(handles.toggleReference, 'Enable', 'off');
        set(handles.menuToggleReference, 'Enable', 'off');
    else
        set(handles.toggleReference, 'Enable', 'on');
        set(handles.menuToggleReference, 'Enable', 'on');
    end
    
    if file.refOn
        set(handles.toggleReference, 'State', 'on');
        set(handles.menuToggleReference, 'Checked', 'on');
    else
        set(handles.toggleReference, 'State', 'off');
        set(handles.menuToggleReference, 'Checked', 'off');
    end
    
    %midline points button
    if isempty(file.midlinePoints)
        set(handles.toggleMidline, 'Enable', 'off');
        set(handles.menuToggleMidline, 'Enable', 'off');
    else
        set(handles.toggleMidline, 'Enable', 'on');
        set(handles.menuToggleMidline, 'Enable', 'on');
    end
    
    if file.midlineOn
        set(handles.toggleMidline, 'State', 'on');
        set(handles.menuToggleMidline, 'Checked', 'on');
    else
        set(handles.toggleMidline, 'State', 'off');
        set(handles.menuToggleMidline, 'Checked', 'off');
    end
    
    %metrics button
    if isempty(file.metricPoints)
        set(handles.toggleMetrics, 'Enable', 'off');
        set(handles.menuToggleMetrics, 'Enable', 'off');
    else
        set(handles.toggleMetrics, 'Enable', 'on');
        set(handles.menuToggleMetrics, 'Enable', 'on');
    end
    
    if file.metricsOn
        set(handles.toggleMetrics, 'State', 'on');
        set(handles.menuToggleMetrics, 'Checked', 'on');
    else
        set(handles.toggleMetrics, 'State', 'off');
        set(handles.menuToggleMetrics, 'Checked', 'off');
    end
    
    if isempty(file.midlinePoints) || isempty(file.tubePoints)
        set(handles.calcMetrics, 'Enable', 'off');
        set(handles.menuCalcMetrics, 'Enable', 'off');
    else
        set(handles.calcMetrics, 'Enable', 'on');
        set(handles.menuCalcMetrics, 'Enable', 'on');
    end
    
    %quick measure button
    if isempty(file.quickMeasurePoints)
        set(handles.toggleQuickMeasure, 'Enable', 'off');
        set(handles.menuToggleQuickMeasure, 'Enable', 'off');
    else
        set(handles.toggleQuickMeasure, 'Enable', 'on');
        set(handles.menuToggleQuickMeasure, 'Enable', 'on');
    end
    
    if file.quickMeasureOn
        set(handles.toggleQuickMeasure, 'State', 'on');
        set(handles.menuToggleQuickMeasure, 'Checked', 'on');
    else
        set(handles.toggleQuickMeasure, 'State', 'off');
        set(handles.menuToggleQuickMeasure, 'Checked', 'off');
    end
    
    %unitPanel buttons
    
    if isempty(file.metricPoints) && isempty(file.quickMeasurePoints)
        updateUnitPanel(handles, 'off', file.displayUnits, file.refPoints);
    else
        updateUnitPanel(handles, 'on', file.displayUnits, file.refPoints);
    end
    
    
    % undo/redo buttons
    
    undoCache = file.undoCache;
    
    if undoCache.cacheLocation == 1
        set(handles.redo, 'Enable', 'off');
        set(handles.menuRedo, 'Enable', 'off');
    else
        set(handles.redo, 'Enable', 'on');
        set(handles.menuRedo, 'Enable', 'on');
    end
    
    if undoCache.cacheLocation == undoCache.numCacheEntries()
        set(handles.undo, 'Enable', 'off');
        set(handles.menuUndo, 'Enable', 'off');
    else
        set(handles.undo, 'Enable', 'on');
        set(handles.menuUndo, 'Enable', 'on');
    end
    
    % tuning button (only available when there are waypoints)
    
    if isempty(file.waypoints)
        set(handles.tuneTube, 'Enable', 'off');
        set(handles.menuTuneTube, 'Enable', 'off');
    else
        set(handles.tuneTube, 'Enable', 'on');
        set(handles.menuTuneTube, 'Enable', 'on');
    end
    
    % longitudinal button (only available when there more than file)
        
    if currentPatient.getNumFiles > 1    
        set(handles.calcLongitudinal, 'Enable', 'on');
        set(handles.toggleLongitudinal, 'Enable', 'on');
        
        set(handles.menuCalcLongitudinal, 'Enable', 'on');
        set(handles.menuToggleLongitudinal, 'Enable', 'on');
    else
        set(handles.calcLongitudinal, 'Enable', 'off');
        set(handles.toggleLongitudinal, 'Enable', 'off');
        
        set(handles.menuCalcLongitudinal, 'Enable', 'off');
        set(handles.menuToggleLongitudinal, 'Enable', 'off');
    end
    
    if currentPatient.longitudinalOn   
        set(handles.toggleLongitudinal, 'State', 'on');
        set(handles.menuToggleLongitudinal, 'Checked', 'on');
    else
        set(handles.toggleLongitudinal, 'State', 'off');
        set(handles.menuToggleLongitudinal, 'Checked', 'off');
    end
    
    % time moving buttons
        
    if currentPatient.currentFileNum == 1
        set(handles.earlierImage, 'Enable', 'off');
        set(handles.earliestImage, 'Enable', 'off');
    else
        set(handles.earlierImage, 'Enable', 'on');
        set(handles.earliestImage, 'Enable', 'on');
    end
    
    if currentPatient.currentFileNum == length(currentPatient.files)
        set(handles.laterImage, 'Enable', 'off');
        set(handles.latestImage, 'Enable', 'off');
    else
        set(handles.laterImage, 'Enable', 'on');
        set(handles.latestImage, 'Enable', 'on');
    end
        
    % save button
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
    end    
    
end