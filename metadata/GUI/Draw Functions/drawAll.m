function [ handles ] = drawAll(currentFile, handles, hObject )
%drawAll Used when switching or opening files to get everything up right
%away

if isempty(currentFile)
    cla(handles.imageAxes);
else
    toggled = false;
    draggable = false;
    labelsOn = true;
    
    handles = drawImage(currentFile, handles);
    
    %handles = drawContrast(handles); %covered by drawImage
    handles = drawWaypoints(currentFile, handles, toggled, draggable);
    handles = drawTube(currentFile, handles, toggled);
    handles = drawRefLineWithCallback(currentFile, handles, hObject, toggled);
    handles = drawMidlineWithCallback(currentFile, handles, hObject, toggled);
    handles = drawMetricLines(currentFile, handles, toggled);
    handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);
    handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);
    handles = drawLongitudinalComparison(getCurrentPatient(handles), handles, toggled);
end


end

