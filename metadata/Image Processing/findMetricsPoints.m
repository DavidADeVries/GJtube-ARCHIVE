function [ metricPoints, handles ] = findMetricsPoints( tubePoints, handles, hObject, invRotMatrix )
%findMetricsPoints takes tubePoints (that have been corrected by rotating
%such that midline is vertical) and then extracts two maximums and a
%minimum

currentFile = getCurrentFile(handles);

pointA = []; %first max after pylorus (will be a min due matlab coords)
pointB = []; %horizontal "min"
pointC = []; %minimum (will be a max due to matlab coords)
pointD = []; %second max (will be min due to matlab coords

extremaRadius = 5; %how many points on each side will be examined to find extrema

for i=1+extremaRadius:length(tubePoints)-extremaRadius
    prePoints = zeros(extremaRadius, 2);
    postPoints = zeros(extremaRadius, 2);
    
    for j=1:extremaRadius
        prePoints(j,:) = tubePoints(i-j,:);
        postPoints(j,:) = tubePoints(i+j,:);
    end
    
    pointX = tubePoints(i,1) .* ones(extremaRadius,1);
    pointY = tubePoints(i,2) .* ones(extremaRadius,1);
    
    preXDiff = mean(pointX - prePoints(:,1));
    preYDiff = mean(pointY - prePoints(:,2));
    
    postXDiff = mean(pointX - postPoints(:,1));
    postYDiff = mean(pointY - postPoints(:,2));
    
    %look for vertical max in matlab coords (point C)
    if preYDiff > 0 && postYDiff > 0
        pointC = applyRotationMatrix(tubePoints(i,:), invRotMatrix);
    end
    
    %look for vertical min in matlab coords (point A or D)
    if preYDiff < 0 && postYDiff < 0
        if isempty(pointB) && isempty(pointC) %still in point A territory
            pointA = applyRotationMatrix(tubePoints(i,:), invRotMatrix);
        else
            pointD = applyRotationMatrix(tubePoints(i,:), invRotMatrix);
        end
    end
    
    %look for hoizontal min in matlab coords (point B)
    if preXDiff < 0 && postXDiff < 0
        pointB = applyRotationMatrix(tubePoints(i,:), invRotMatrix);            
    end   
end

% manually select pylorus

message = 'Please select the pylorus.';

point = manualPointSelection(message);

pylorus = confirmNonRoi(point, currentFile.roiOn, currentFile.roiCoords);

metricPoints = MetricPoints(pylorus, pointA, pointB, pointC, pointD);

currentFile.metricPoints = metricPoints;
currentFile.metricsOn = true;

% delete what was there previously
handles = deleteMetricLines(handles);
handles = deleteMetricPoints(handles);

% temporarily draw what points we have
toggled = false;
labelsOn = false;

handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);

% now make sure none of the points A - D are missing
points = {pointA, pointB, pointC, pointD};
labels = {'Point A', 'Point B', 'Point C', 'Point D'};
descriptors = {...
    'Point A is the first vertical maximum after the pylorus.',...
    'Point B is the leftmost point after the pylorus',...
    'Point C is the first vertical minimum after the pylorus.',...
    'Point D is the second vertical maximum after the pylorus.'};

for i=1:length(points)
    if isempty(points{i})
        line1 = char(strcat(labels{i}, {' '}, 'was not automatically found. Please manually select.'));
        line2 = char(descriptors{i});
        
        point = manualPointSelection({line1; line2});
        point = confirmNonRoi(point, currentFile.roiOn, currentFile.roiCoords);
        points{i} = point;
        
        handles = deleteMetricPoints(handles);
        
        metricPoints = MetricPoints(pylorus, points{1}, points{2}, points{3}, points{4});
        currentFile.metricPoints = metricPoints;
        
        % temporarily draw what points we have
        toggled = false;
        handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);
    end
end

% delete what was temporarily drawn

handles = deleteMetricPoints(handles);
    
end

function point = manualPointSelection(message)
    title = 'Select Point';
    icon = 'warn';
    waitfor(msgbox(message,title,icon));
    
    point = ginput(1);
end


