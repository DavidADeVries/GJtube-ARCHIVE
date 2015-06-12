function [ handles ] = drawMetricLines(currentFile, handles, toggled)
%drawMetricLines updates the the metric lines and labels, if they exist. Since
%these labels are text, they are stored in a TextLabel class. If they do
%not exist, new ones are created

textLabels = handles.metricLineTextLabels;
displayLines = handles.metricLineDisplayLines;

if currentFile.metricsOn
    if isempty(textLabels) || isempty(displayLines) %create new 
        metricLines = calcMetricLines(currentFile);
        
        [ unitString, unitConversion ] = currentFile.getUnitConversion();
        
        numMetricLines = length(metricLines);
        
        %constants
        labelBorderColour = Constants.METRIC_LINE_LABEL_BORDER_COLOUR;
        textColour = Constants.METRIC_LINE_LABEL_TEXT_COLOUR;
        fontSize = Constants.METRIC_LINE_LABEL_FONT_SIZE;
        
        lineBorderColour = Constants.METRIC_LINE_BORDER_COLOUR;
        lineWidth = Constants.METRIC_LINE_WIDTH;
        lineColour = Constants.METRIC_LINE_COLOUR;
        arrowEnds = Constants.METRIC_LINE_ARROW_ENDS;
        
        %create lines
        textLabels = TextLabel.empty(numMetricLines, 0);
        displayLines = DisplayLine.empty(numMetricLines, 0);
        
        for i=1:numMetricLines
            displayLines(i) = DisplayLine(metricLines(i), lineBorderColour, lineColour, lineWidth, arrowEnds);
            textLabels(i) = TextLabel(metricLines(i), unitString, unitConversion, labelBorderColour, textColour, fontSize);
        end
        
        % push up update
        handles.metricLineTextLabels = textLabels;
        handles.metricLineDisplayLines = displayLines;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            for i=1:length(textLabels)
                textLabels(i).setVisible('on');
                displayLines(i).setVisible('on');
            end
        end
        
        %update them
        metricLines = calcMetricLines(currentFile);
        
        [ unitString, unitConversion ] = currentFile.getUnitConversion();
        
        numMetricLines = length(metricLines);
        
        for i=1:numMetricLines
            textLabels(i).update(metricLines(i), unitString, unitConversion);
            displayLines(i).update(metricLines(i));
        end
    end      
else %turn it off
    if ~isempty(textLabels) && ~isempty(displayLines) %if the objects exist, turn them off
        for i=1:length(textLabels)
            textLabels(i).setVisible('off');
            displayLines(i).setVisible('off');
        end
    end
end

end

