function [ ] = saveRefLinePoints(hObject)
%saveRefLinePoints as the ref linen is dragged around in real-time, the
%position is pushed back up to the refPoints field

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

refPoints = getPosition(handles.refLineHandle);

currentFile = currentFile.setRefPoints(refPoints);

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

