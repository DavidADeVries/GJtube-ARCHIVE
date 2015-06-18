function [ handles ] = drawMetricLines(currentFile, handles, toggled)
%drawMetricLines updates the the metric lines and labels, if they exist. Since
%these labels are text, they are stored in a TextLabel class. If they do
%not exist, new ones are created

textLabels = handles.metricLineTextLabels;
displayLines = handles.metricLineDisplayLines;

if currentFile.metricsOn
    if isempty(textLabels) || isempty(displayLines) %create new 
        metricLines = calcMetricLines(currentFile);
        tubeMetricStrings = currentFile.getTubeMetricStrings();
        
        [ unitString, unitConversion ] = currentFile.getUnitConversion();
        
        numMetricLines = length(metricLines);
        numTubeMetrics = length(tubeMetricStrings);
        
        %constants
        labelBorderColour = Constants.METRIC_LINE_LABEL_BORDER_COLOUR;
        textColour = Constants.METRIC_LINE_LABEL_TEXT_COLOUR;
        fontSize = Constants.METRIC_LINE_LABEL_FONT_SIZE;
        
        lineBorderColour = Constants.METRIC_LINE_BORDER_COLOUR;
        lineWidth = Constants.METRIC_LINE_WIDTH;
        lineColour = Constants.METRIC_LINE_COLOUR;
        lineArrowEnds = Constants.METRIC_LINE_ARROW_ENDS;
        
        bridgeColour = Constants.METRIC_LINE_BRIDGE_COLOUR;
        bridgeArrowEnds = Constants.METRIC_LINE_BRIDGE_ARROW_ENDS;
        
        %create lines
        textLabels = TextLabel.empty(numMetricLines + numTubeMetrics, 0);
        displayLines = DisplayLine.empty(numMetricLines, 0); %tube metrics don't need a line
        
        %display metric lines
        for i=1:numMetricLines
            if metricLines(i).isBridge
                arrowEnds = bridgeArrowEnds;
                arrowColour = bridgeColour;
            else
                arrowEnds = lineArrowEnds;
                arrowColour = lineColour;
            end
            
            displayLines(i) = DisplayLine(metricLines(i), lineBorderColour, arrowColour, lineWidth, arrowEnds);
            textLabels(i) = TextLabel(metricLines(i), unitString, unitConversion, labelBorderColour, textColour, fontSize);
        end
        
        % display tube metrics
        for i=1:numTubeMetrics
            point = [1,1]; %display in upper corner
            textLabel = TextLabel(point, tubeMetricStrings{i}, labelBorderColour, textColour, fontSize);
            
            textLabel.setAbsolutePosition([5, (i*20) - 7]);          
            
            textLabels(numMetricLines+i) = textLabel;
        end
        
        % push up update
        handles.metricLineTextLabels = textLabels;
        handles.metricLineDisplayLines = displayLines;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            for i=1:length(textLabels)
                textLabels(i).setVisible('on');
            end
            
            for i=1:length(displayLines)
                displayLines(i).setVisible('on');
            end
        end
        
        %update them
        metricLines = calcMetricLines(currentFile);
        tubeMetricStrings = currentFile.getTubeMetricStrings();
        
        [ unitString, unitConversion ] = currentFile.getUnitConversion();
        
        numMetricLines = length(metricLines);
        numTubeMetrics = length(tubeMetricStrings);
        
        for i=1:numMetricLines
            textLabels(i).update(metricLines(i), unitString, unitConversion);
            displayLines(i).update(metricLines(i));
        end
        
        for i=1:numTubeMetrics
            textLabels(numMetricLines+i).update([1,1], tubeMetricStrings{i});
            
            textLabels(numMetricLines+i).setAbsolutePosition([5, (i*20) - 7]); 
        end
    end      
else %turn it off
    if ~isempty(textLabels) && ~isempty(displayLines) %if the objects exist, turn them off
        for i=1:length(textLabels)
            textLabels(i).setVisible('off');
        end
        
        for i=1:length(displayLines)
            displayLines(i).setVisible('off');
        end
    end
end

end

