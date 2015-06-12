function [ ] = saveMidlinePoints(hObject)
%saveMidlinePoints as the midline is dragged around in real-time, the
%position is pushed back up to the midlinePoints field

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

midlinePoints = getPosition(handles.midlineHandle);

currentFile = currentFile.setMidlinePoints(midlinePoints);

% updateUndo/pendingChanges should only be done at end of click and drag
% (clickup listener callback)
updateUndo = false;
pendingChanges = false;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update other components as needed
toggled = false;

handles = drawMetricLines(currentFile, handles, toggled);

%push up changes
guidata(hObject, handles);

end

