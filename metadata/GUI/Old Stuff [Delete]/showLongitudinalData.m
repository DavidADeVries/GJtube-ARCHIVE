function [ handles  ] = showLongitudinalData(handles, currentPatient)
%showLongitudinalData displays all the tubes over time for the patient
%given

currentPatient = currentPatient.updateLongitudinalFileNumbers();

[listboxLabels, listboxValues] = currentPatient.getLongitudinalListboxData();

set(handles.longitudinalListbox, 'String', listboxLabels, 'Value', listboxValues);

currentFile = currentPatient.getCurrentFile();

baseRefPoints = currentFile.refPoints;

longitudinalFileNumbers = currentPatient.getLongitudinalDisplayFileNumbers();

%As time increases, tubes go from blue to purple
%R: 0 -> 153
%G: 127 -> 51
%B: 255 -> 255

numTubes = length(longitudinalFileNumbers);

redShift = (153 - 0)/numTubes;
greenShift = (51 - 127)/numTubes;
blueShift = 0;

numDeltaLines = 3*(numTubes -1); %between each tube, 3 metric points each

deltaLines = Line.empty(numDeltaLines, 0);

for i=1:numTubes
    file = currentPatient.files(longitudinalFileNumbers(i));
    
    [shift, scale, angleShift, angle] = getTransformParams(baseRefPoints, file.refPoints);
    
    transform = getTransform(shift, scale, angleShift, angle);
    
    [x,y] = transformPointsForward(transform, file.tubePoints(:,1), file.tubePoints(:,2));
    
    transformTubePoints = [x,y];
    
    [x,y] = transformPointsForward(transform, file.metricPoints(:,1), file.metricPoints(:,2));
    
    transformMetricPoints = [x,y];
    
    if currentFile.roiOn
        transformTubePoints = nonRoiToRoi(currentFile.roiCoords, transformTubePoints);
        transformMetricPoints = nonRoiToRoi(currentFile.roiCoords, transformMetricPoints);
    end
    
    r = 0 + i*redShift;
    g = 127 + i*greenShift;
    b = 255 + i*blueShift;
    
    baseColor = [r,g,b]/255;
    
    plotTubePoints(transformTubePoints, 'line', baseColor);
    plotMetricPoints(transformMetricPoints, handles.imageDisplay);
    
    if i ~= numTubes
        deltaLines(((i-1)*3)+1).startPoint = transformMetricPoints(1,:);
        deltaLines(((i-1)*3)+2).startPoint = transformMetricPoints(2,:);
        deltaLines(((i-1)*3)+3).startPoint = transformMetricPoints(3,:);
    end
    
    if i ~= 1
        deltaLines(((i-2)*3)+1).endPoint = transformMetricPoints(1,:);
        deltaLines(((i-2)*3)+2).endPoint = transformMetricPoints(2,:);
        deltaLines(((i-2)*3)+3).endPoint = transformMetricPoints(3,:);
    end
end

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
        
deltaLines = setTagStrings(deltaLines, unitString, unitConversion);

plotDeltaLines(deltaLines);

handles = pushUpPatientChanges(handles, currentPatient);


end

