function [ handles ] = deleteMetricPoints( handles )
%deleteMetricPoints deletes the all the handles associated with the metric points. Updates
%handles to reflect this

metricPointHandles = handles.metricPointHandles;

for i=1:length(metricPointHandles)
    delete(metricPointHandles(i));
end

handles.metricPointHandles = impoint.empty;

end

