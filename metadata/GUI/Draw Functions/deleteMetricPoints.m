function [ handles ] = deleteMetricPoints( handles )
%deleteMetricPoints deletes the all the handles associated with the metric points. Updates
%handles to reflect this

metricPointHandles = handles.metricPointHandles;
metricPointTextLabels = handles.metricPointTextLabels;

for i=1:length(metricPointHandles)
    delete(metricPointHandles(i));
end

for i=1:length(metricPointTextLabels)
    metricPointTextLabels(i).delete();
end

handles.metricPointHandles = impoint.empty;
handles.metricPointTextLabels = TextLabel.empty;

end

