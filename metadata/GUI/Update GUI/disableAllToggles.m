function [ ] = disableAllToggles( handles )
%disableAllToggles used when no patients are open to just lock everything
%down

set(handles.patientSelector, 'Enable', 'off');

set(handles.open, 'Enable', 'off');
set(handles.savePatient, 'Enable', 'off');
set(handles.saveAll, 'Enable', 'off');
set(handles.closePatient, 'Enable', 'off');
set(handles.removeFile, 'Enable', 'off');
set(handles.undo, 'Enable', 'off');
set(handles.redo, 'Enable', 'off');
set(handles.earliestImage, 'Enable', 'off');
set(handles.earlierImage, 'Enable', 'off');
set(handles.laterImage, 'Enable', 'off');
set(handles.latestImage, 'Enable', 'off');
set(handles.zoomIn, 'Enable', 'off');
set(handles.zoomOut, 'Enable', 'off');
set(handles.pan, 'Enable', 'off');
set(handles.selectContrast, 'Enable', 'off');
set(handles.selectRoi, 'Enable', 'off');
set(handles.selectWaypoints, 'Enable', 'off');
set(handles.segmentTube, 'Enable', 'off');
set(handles.tuneTube, 'Enable', 'off');
set(handles.selectReference, 'Enable', 'off');
set(handles.selectMidline, 'Enable', 'off');
set(handles.calcMetrics, 'Enable', 'off');
set(handles.calcLongitudinal, 'Enable', 'off');
set(handles.quickMeasure, 'Enable', 'off');
set(handles.toggleContrast, 'Enable', 'off');
set(handles.toggleRoi, 'Enable', 'off');
set(handles.toggleWaypoints, 'Enable', 'off');
set(handles.toggleTube, 'Enable', 'off');
set(handles.toggleReference, 'Enable', 'off');
set(handles.toggleMidline, 'Enable', 'off');
set(handles.toggleMetrics, 'Enable', 'off');
set(handles.toggleLongitudinal, 'Enable', 'off');
set(handles.toggleQuickMeasure, 'Enable', 'off');

% don't even want to see these ones
set(handles.generalAccept, 'Visible', 'off');
set(handles.generalDecline, 'Visible', 'off');

set(handles.menuOpen, 'Enable', 'off');
set(handles.menuSavePatient, 'Enable', 'off');
set(handles.menuSavePatientAs, 'Enable', 'off');
set(handles.menuSaveAll, 'Enable', 'off');
set(handles.menuClosePatient, 'Enable', 'off');
set(handles.menuRemoveFile, 'Enable', 'off');
set(handles.menuUndo, 'Enable', 'off');
set(handles.menuRedo, 'Enable', 'off');
% set(handles.menuEarliestImage, 'Enable', 'off');
% set(handles.menuearlierImage, 'Enable', 'off');
% set(handles.menulaterImage, 'Enable', 'off');
% set(handles.menulatestImage, 'Enable', 'off');
% set(handles.menuZoomIn, 'Enable', 'off');
% set(handles.menuZoomOut, 'Enable', 'off');
% set(handles.menuPan, 'Enable', 'off');
set(handles.menuSelectContrast, 'Enable', 'off');
set(handles.menuSelectRoi, 'Enable', 'off');
set(handles.menuSelectWaypoints, 'Enable', 'off');
set(handles.menuSegmentTube, 'Enable', 'off');
set(handles.menuTuneTube, 'Enable', 'off');
set(handles.menuSelectReference, 'Enable', 'off');
set(handles.menuSelectMidline, 'Enable', 'off');
set(handles.menuCalcMetrics, 'Enable', 'off');
set(handles.menuCalcLongitudinal, 'Enable', 'off');
set(handles.menuQuickMeasure, 'Enable', 'off');

set(handles.menuToggleContrast, 'Enable', 'off');
set(handles.menuToggleRoi, 'Enable', 'off');
set(handles.menuToggleWaypoints, 'Enable', 'off');
set(handles.menuToggleTube, 'Enable', 'off');
set(handles.menuToggleReference, 'Enable', 'off');
set(handles.menuToggleMidline, 'Enable', 'off');
set(handles.menuToggleMetrics, 'Enable', 'off');
set(handles.menuToggleLongitudinal, 'Enable', 'off');
set(handles.menuToggleQuickMeasure, 'Enable', 'off');

set(handles.menuToggleContrast, 'Checked', 'off');
set(handles.menuToggleRoi, 'Checked', 'off');
set(handles.menuToggleWaypoints, 'Checked', 'off');
set(handles.menuToggleTube, 'Checked', 'off');
set(handles.menuToggleReference, 'Checked', 'off');
set(handles.menuToggleMidline, 'Checked', 'off');
set(handles.menuToggleMetrics, 'Checked', 'off');
set(handles.menuToggleLongitudinal, 'Checked', 'off');
set(handles.menuToggleQuickMeasure, 'Checked', 'off');

end

