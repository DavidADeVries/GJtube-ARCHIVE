function [ ] = saveQuickMeasurePoints( hObject)
%saveQuickMeasurePoints as quick measure line is dragged around in real-time, their
%position is pushed back up to the quickMeasurePoint field. Label is also
%updated

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

quickMeasurePoints = getPosition(handles.quickMeasureLineHandle);

currentFile = currentFile.setQuickMeasurePoints(quickMeasurePoints);

% updateUndo/pendingChanges should only be done at end of click and drag
% (clickup listener callback)
updateUndo = false;
changesPending = false;

handles = updateFile(currentFile, updateUndo, changesPending, handles);

%update line/text
toggled = false;

handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

%push up changes
guidata(hObject, handles);

end

