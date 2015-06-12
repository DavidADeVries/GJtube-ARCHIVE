function [ handles ] = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled)
%drawMetricPointsWithCallback draws the metric points as well as puts the
%callback together to save points as it is clicked and dragged

metricPointHandles = handles.metricPointHandles;

metricPoints = currentFile.getMetricPoints();

numMetricPoints = length(metricPoints);

if currentFile.metricsOn
    if isempty(metricPointHandles) %create new
        % constants
        colour = Constants.METRIC_POINT_COLOUR;
        
        metricPointHandles = impoint.empty(numMetricPoints,0);
        
        % draw points
        for i=1:numMetricPoints
            impointHandle = impoint(handles.imageAxes, metricPoints(i,1), metricPoints(i,2));
            setColor(impointHandle, colour);
            
            % add callback for click and drag action!
            func = @(pos) saveMetricPoints(hObject);
            addNewPositionCallback(impointHandle, func);
            
            metricPointHandles(i) = impointHandle;
        end
        
        % push up update
        handles.metricPointHandles = metricPointHandles;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            for i=1:numMetricPoints
                set(metricPointHandles(i), 'Visible', 'on');
            end
        else
            %update them
            for i=1:numMetricPoints
                setPosition(metricPointHandles(i), metricPoints(i,1), metricPoints(i,2)); %watch out this triggers the callback!
            end
        end
    end
else %turn it off
    if ~isempty(metricPointHandles) %if the objects exist, turn them off
        for i=1:numMetricPoints
            set(metricPointHandles(i), 'Visible', 'off');
        end
    end
end


end

