function [ handles ] = drawLongitudinalComparison(currentPatient, handles, toggled)
%drawLongitudinalComparison draws all segmented tubes that have been found
%for all the files for a patient, overlaying them ontop of the current
%image

longitudinalDisplayTubes = handles.longitudinalDisplayTubes;
deltaLineDisplayLines = handles.deltaLineDisplayLines;
deltaLineTextLabels = handles.deltaLineTextLabels;

currentFile = currentPatient.getCurrentFile();

if currentPatient.longitudinalOn
    baseRefPoints = currentFile.refPoints;
    longitudinalFileNumbers = currentPatient.getLongitudinalDisplayFileNumbers();
    numTubes = length(longitudinalFileNumbers);
    if isempty(longitudinalDisplayTubes) || isempty(deltaLineDisplayLines) || isempty(deltaLineTextLabels) %create new
        %constants
        
        %for tube
        startColour = Constants.LONGITUDINAL_START_COLOUR; %each tube drawn will be a different colour
        endColour = Constants.LONGITUDINAL_END_COLOUR;
        
        style = Constants.TUBE_STYLE;
        borderColour = Constants.TUBE_BORDER_COLOUR;
        lineWidth = Constants.TUBE_WIDTH;
        borderWidth = Constants.TUBE_BORDER_WIDTH;
        
        metricPointColour = Constants.METRIC_POINT_COLOUR;
        draggable = false; %metric points should not be dragged
        
        %for delta lines
        deltaLineLabelBorderColour = Constants.DELTA_LINE_LABEL_BORDER_COLOUR;
        deltaLineLabelTextColour = Constants.DELTA_LINE_LABEL_TEXT_COLOUR;
        deltaLineLabelFontSize = Constants.DELTA_LINE_LABEL_FONT_SIZE;
        
        deltaLineBorderColour = Constants.DELTA_LINE_BORDER_COLOUR;
        deltaLineWidth = Constants.DELTA_LINE_WIDTH;
        deltaLineColour = Constants.DELTA_LINE_COLOUR;
        deltaLineArrowEnds = Constants.DELTA_LINE_ARROW_ENDS;
        
        % calculate colour increments for gradient colour shift between
        % lines 
        redShift = (endColour(1) - startColour(1))/numTubes;
        greenShift = (endColour(2) - startColour(2))/numTubes;
        blueShift = (endColour(3) - startColour(3))/numTubes;
        
        numDeltaLines = 5*(numTubes -1); %between each tube, 5 metric points each
        
        deltaLines = Line.empty(numDeltaLines, 0);
        
        for i=1:numTubes
            file = currentPatient.files(longitudinalFileNumbers(i));
            
            [shift, scale, angleShift, angle] = getTransformParams(baseRefPoints, file.refPoints);
            
            transform = getTransform(shift, scale, angleShift, angle);
            
            [x,y] = transformPointsForward(transform, file.tubePoints(:,1), file.tubePoints(:,2));
            
            transformTubePoints = [x,y];
            
            metricPointsCoords = file.metricPoints.getPoints();
            
            [x,y] = transformPointsForward(transform, metricPointsCoords(:,1), metricPointsCoords(:,2));
            
            transformMetricPoints = [x,y];
            
            if currentFile.roiOn
                transformTubePoints = nonRoiToRoi(currentFile.roiCoords, transformTubePoints);
                transformMetricPoints = nonRoiToRoi(currentFile.roiCoords, transformMetricPoints);
            end
            
            r = startColour(1) + i*redShift;
            g = startColour(2) + i*greenShift;
            b = startColour(3) + i*blueShift;
            
            baseColour = [r,g,b];
            
            longitudinalDisplayTubes(i) = LongitudinalDisplayTube(...
                                    transformTubePoints,... 
                                    transformMetricPoints,...
                                    metricPointColour, draggable, handles.imageAxes,... %metric point constants
                                    style, lineWidth, borderWidth, borderColour, baseColour); %tube constants
                        
            if i ~= numTubes
                deltaLines(((i-1)*5)+1).startPoint = transformMetricPoints(1,:);
                deltaLines(((i-1)*5)+2).startPoint = transformMetricPoints(2,:);
                deltaLines(((i-1)*5)+3).startPoint = transformMetricPoints(3,:);
                deltaLines(((i-1)*5)+4).startPoint = transformMetricPoints(4,:);
                deltaLines(((i-1)*5)+5).startPoint = transformMetricPoints(5,:);
            end
            
            if i ~= 1
                deltaLines(((i-2)*5)+1).endPoint = transformMetricPoints(1,:);
                deltaLines(((i-2)*5)+2).endPoint = transformMetricPoints(2,:);
                deltaLines(((i-2)*5)+3).endPoint = transformMetricPoints(3,:);
                deltaLines(((i-2)*5)+4).endPoint = transformMetricPoints(4,:);
                deltaLines(((i-2)*5)+5).endPoint = transformMetricPoints(5,:);
            end
        end
        
        handles.longitudinalDisplayTubes = longitudinalDisplayTubes;
        
        for i=1:numDeltaLines
            if (mod(i,3) - 1) == 0 %left lines
                deltaLines(i).textAlign = 'right';
                horzOffset = -3;
            else %middle and right lines
                deltaLines(i).textAlign = 'left';
                horzOffset = 3;
            end
            
            halfwayPoint = deltaLines(i).getHalfwayPoint();
            tagPoint = [halfwayPoint(1)+horzOffset,halfwayPoint(2)];
            
            deltaLines(i).tagPoint = tagPoint;
        end
        
        [unitString, unitConversion] = getUnitConversion(currentPatient.getCurrentFile());
                
        numDeltaLines = length(deltaLines);
        
        deltaLineTextLabels = TextLabel.empty(numDeltaLines, 0);
        deltaLineDisplayLines = DisplayLine.empty(numDeltaLines, 0);
        
        for i=1:numDeltaLines
            deltaLineDisplayLines(i) = DisplayLine(deltaLines(i), deltaLineBorderColour, deltaLineColour, deltaLineWidth, deltaLineArrowEnds);
            deltaLineTextLabels(i) = TextLabel(deltaLines(i), unitString, unitConversion, deltaLineLabelBorderColour, deltaLineLabelTextColour, deltaLineLabelFontSize);
        end
        
        handles.deltaLineTextLabels = deltaLineTextLabels;
        handles.deltaLineDisplayLines = deltaLineDisplayLines;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            for i=1:length(longitudinalDisplayTubes)
                longitudinalDisplayTubes(i).setVisible('on');
            end
            
            for i=1:length(deltaLineTextLabels)
                deltaLineTextLabels(i).setVisible('on');
                deltaLineDisplayLines(i).setVisible('on');
            end
        end
        
        %update line        
    end      
else %turn it off
    if ~(isempty(longitudinalDisplayTubes) || isempty(deltaLineDisplayLines) || isempty(deltaLineTextLabels)) %if the objects exist, turn them off
        for i=1:length(longitudinalDisplayTubes)
            longitudinalDisplayTubes(i).setVisible('off');
        end
        
        for i=1:length(deltaLineTextLabels)
            deltaLineTextLabels(i).setVisible('off');
            deltaLineDisplayLines(i).setVisible('off');
        end
    end
end

end

