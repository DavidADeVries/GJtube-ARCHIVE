function [ ] = saveMetricPoints(hObject)
%saveMetricPoints as metric points are dragged around in real-time, their
%position is pushed back up to the metricPoints field

handles = guidata(hObject);

handles.updateUndoCache = true; %make sure the undo updater is waiting on click up

currentFile = getCurrentFile(handles);

metricPointHandles = handles.metricPointHandles;

numMetricPointHandles = length(metricPointHandles);

metricPointCoords = zeros(numMetricPointHandles,2);

for i=1:numMetricPointHandles
    metricPointCoords(i,:) = getPosition(metricPointHandles(i));
end

currentFile = currentFile.updateMetricPoints(metricPointCoords);

% updateUndo/pendingChanges should only be done at end of click and drag
% (clickup listener callback)
updateUndo = false;
pendingChanges = false;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update other components as needed
toggled = false;
labelsOn = true;

handles = drawMetricLines(currentFile, handles, toggled);
handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);

% push up changes
guidata(hObject, handles);


end

