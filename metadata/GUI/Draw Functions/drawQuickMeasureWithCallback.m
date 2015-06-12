function [ handles ] = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled)
%drawQuickMeasureWithCallback draws the quick measure line as well as puts the
%callback together to save points as it is clicked and dragged

quickMeasureLineHandle = handles.quickMeasureLineHandle;
quickMeasureTextLabel = handles.quickMeasureTextLabel;

quickMeasurePoints = currentFile.getQuickMeasurePoints();

if currentFile.quickMeasureOn
    if isempty(quickMeasureLineHandle) || isempty(quickMeasureTextLabel) %create new
        % constants
        lineColour = Constants.QUICK_MEASURE_LINE_COLOUR;
        labelBorderColour = Constants.QUICK_MEASURE_LABEL_BORDER_COLOUR;
        textColour = Constants.QUICK_MEASURE_LABEL_TEXT_COLOUR;
        fontSize = Constants.QUICK_MEASURE_LABEL_FONT_SIZE;
        
        % draw line
        quickMeasureLineHandle = imline(handles.imageAxes, quickMeasurePoints(:,1), quickMeasurePoints(:,2));
        setColor(quickMeasureLineHandle, lineColour);
        
        % draw label
        %create Line with quick measure points to allow use of commom fns
        %with drawMetricLines
        line = createQuickMeasureLine(quickMeasurePoints);
        
        [unitString, unitConversion] = currentFile.getUnitConversion();
        
        textLabel = TextLabel(line, unitString, unitConversion, labelBorderColour, textColour, fontSize);
        
        % add callback for click and drag action!
        func = @(pos) saveQuickMeasurePoints(hObject);
        addNewPositionCallback(quickMeasureLineHandle, func);
        
        % push up update
        handles.quickMeasureLineHandle = quickMeasureLineHandle;
        handles.quickMeasureTextLabel = textLabel;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            set(quickMeasureLineHandle, 'Visible', 'on');
            quickMeasureTextLabel.setVisible('on');
        end
        
        %update them
        line = createQuickMeasureLine(quickMeasurePoints);
        [unitString, unitConversion] = currentFile.getUnitConversion();
        
        setPosition(quickMeasureLineHandle, quickMeasurePoints(:,1), quickMeasurePoints(:,2));
        quickMeasureTextLabel.update(line, unitString, unitConversion);
    end
else %turn it off
    if ~isempty(quickMeasureLineHandle) && ~isempty(quickMeasureTextLabel) %if the objects exist, turn them off
        set(quickMeasureLineHandle, 'Visible', 'off');
        quickMeasureTextLabel.setVisible('off');
    end
end

end

function line = createQuickMeasureLine(quickMeasurePoints)
startPoint = quickMeasurePoints(1,:);
endPoint = quickMeasurePoints(2,:);

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
vertOffset = 5;
tagPoint = [halfwayPoint(1), halfwayPoint(2)+vertOffset];

line = Line(startPoint, endPoint, tagPoint, 'left');
end

