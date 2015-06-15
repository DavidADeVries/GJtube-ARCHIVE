function [ handles ] = deleteMetricLines( handles )
%deleteMetricLines deletes the all the handles associated with the metric lines. Updates
%handles to reflect this

textLabels = handles.metricLineTextLabels;
displayLines = handles.metricLineDisplayLines;

for i=1:length(textLabels)
    textLabels(i).delete();
end

for i=1:length(displayLines)
    displayLines(i).delete();
end

handles.metricLineTextLabels = TextLabel.empty;
handles.metricLineDisplayLines = DisplayLine.empty;

end

