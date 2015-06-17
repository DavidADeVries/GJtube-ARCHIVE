function [ handles ] = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn)
%drawMetricPointsWithCallback draws the metric points as well as puts the
%callback together to save points as it is clicked and dragged

metricPointHandles = handles.metricPointHandles;
textLabels = handles.metricPointTextLabels;

metricPoints = currentFile.metricPoints();

if ~isempty(metricPoints)
    points = metricPoints.getPointCoords(currentFile);
    
    numPoints = height(points);
    
    if currentFile.metricsOn
        if isempty(metricPointHandles) %create new
            % constants
            colour = Constants.METRIC_POINT_COLOUR;
            
            labelBorderColour = Constants.METRIC_POINT_LABEL_BORDER_COLOUR; %black
            labelTextColour = Constants.METRIC_POINT_LABEL_TEXT_COLOUR; %yellow
            labelFontSize = Constants.METRIC_POINT_LABEL_FONT_SIZE;
            
            labels = metricPoints.getLabels();
            labelOffsets = metricPoints.getLabelOffsets();
            
            metricPointHandles = impoint.empty(numPoints,0);
            
            if labelsOn
                textLabels = TextLabel.empty(numPoints,0);
            end
                       
            % draw points
            for i=1:numPoints
                impointHandle = impoint(handles.imageAxes, points(i,1), points(i,2));
                setColor(impointHandle, colour);
                       
                % add callback for click and drag action!
                func = @(pos) saveMetricPoints(hObject);
                addNewPositionCallback(impointHandle, func);
                
                metricPointHandles(i) = impointHandle;
                
                if labelsOn
                    textLabels(i) = TextLabel(points(i,:)+labelOffsets(i,:), labels{i}, labelBorderColour, labelTextColour, labelFontSize);
                end
            end
            
            % push up update
            handles.metricPointHandles = metricPointHandles;
            handles.metricPointTextLabels = textLabels;
        else %handles not empty, the elements already exist, so just update
            if toggled %set visiblity
                for i=1:numPoints
                    set(metricPointHandles(i), 'Visible', 'on');
                    textLabels(i).setVisible('on');
                end
            else
                labelOffsets = metricPoints.getLabelOffsets();
                %update them
                for i=1:numPoints
                    %THIS IS A HACK! TODO: develop a sort of 'mute' for the
                    %callbacks, so that positions can be updated without
                    %their callback listeners being triggered
                    %setPosition(metricPointHandles(i), points(i,1), points(i,2)); %watch out this triggers the callback!
                    textLabels(i).update(points(i,:) + labelOffsets(i,:));
                end
            end
        end
    else %turn it off
        if ~isempty(metricPointHandles) && ~isempty(textLabels) %if the objects exist, turn them off
            for i=1:numPoints
                set(metricPointHandles(i), 'Visible', 'off');
                textLabels(i).setVisible('off');
            end
        end        
    end
end


end

