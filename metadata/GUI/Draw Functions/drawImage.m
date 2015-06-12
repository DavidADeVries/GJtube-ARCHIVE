function [ handles ] = drawImage( currentFile, handles )
%drawImage draws the actual image itself, no lines or other points are
%drawn

image = currentFile.getCurrentImage(); %either ROI or not
cLim = currentFile.getCurrentLimits();

axes(handles.imageAxes);

imshow(image,cLim);

%clear all other handles because imshow killed everything
handles.waypointHandles = impoint.empty;
handles.displayTube = DisplayTube.empty;
handles.metricLineTextLabels = TextLabel.empty;
handles.metricLineDisplayLines = DisplayLine.empty;
handles.metricPointHandles = impoint.empty;
handles.refLineHandle = imline.empty;
handles.midlineHandle = imline.empty;
handles.quickMeasureLineHandle = imline.empty;
handles.quickMeasureTextLabel = TextLabel.empty;

handles.longitudinalDisplayTubes = LongitudinalDisplayTube.empty;
handles.deltaLineTextLabels = TextLabel.empty;
handles.deltaLineDisplayLines = DisplayLine.empty;

end

