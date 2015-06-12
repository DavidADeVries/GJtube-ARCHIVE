function [ lines ] = calcMetricLines(file)
%calcMetricLines given a file, a list of lines of are
%given back, where each line is of the Line class

midlinePoints = file.midlinePoints;
metricPoints = file.metricPoints;
roiOn = file.roiOn;
roiCoords = file.roiCoords;

corAngle = findCorrectionAngle(midlinePoints);

rotMatrix = [cosd(corAngle) -sind(corAngle); sind(corAngle) cosd(corAngle)];
invRotMatrix = [cosd(-corAngle) -sind(-corAngle); sind(-corAngle) cosd(-corAngle)];

% first rotate extrema points into coord system such that midline is
% vertical

rotExtremaPoints = applyRotationMatrix(metricPoints, rotMatrix);
rotMidlinePoints = applyRotationMatrix(midlinePoints, rotMatrix);

midlineX = rotMidlinePoints(1,1);

maxL = rotExtremaPoints(1,:);
min = rotExtremaPoints(2,:);
maxR = rotExtremaPoints(3,:);

maxLX = maxL(1);
maxLY = maxL(2);
minX = min(1);
minY = min(2);
maxRX = maxR(1);
maxRY = maxR(2);

% create the lines

%offsets so that labels don't lie directly on lines
vertOffset = -3; %px
horzOffset = -3; %px

% maxL to maxR horz:
startPoint = [maxLX,maxRY];
endPoint = [maxRX,maxRY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(1) = Line(startPoint, endPoint, tagPoint, 'left');

% maxL to maxR vert:
startPoint = [maxLX,maxLY];
endPoint = [maxLX,maxRY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1)+horzOffset,halfwayPoint(2)];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(2) = Line(startPoint, endPoint, tagPoint, 'right');

% maxL to midline:
startPoint = [maxLX,maxLY];
endPoint = [midlineX,maxLY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1),halfwayPoint(2) + vertOffset];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(3) = Line(startPoint, endPoint, tagPoint, 'left');

% maxR to midline:
startPoint = [midlineX,maxLY];
endPoint = [maxRX,maxLY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1),halfwayPoint(2) + vertOffset];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(4) = Line(startPoint, endPoint, tagPoint, 'left');

% min to maxL vert:
startPoint = [minX,minY];
endPoint = [minX,maxLY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1)+horzOffset,halfwayPoint(2)];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(5) = Line(startPoint, endPoint, tagPoint, 'right');

% min to midline:
halfwayPoint = getHalfwayPoint(maxL, min); 
% this line is not directly touching any points, so the y val will be
% halfway between two points
yVal = halfwayPoint(2);

startPoint = [minX,yVal];
endPoint = [midlineX,yVal];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1),halfwayPoint(2)+vertOffset];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(6) = Line(startPoint, endPoint, tagPoint, 'left');

% min to maxR horz:
startPoint = [minX,minY];
endPoint = [maxRX,minY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1),halfwayPoint(2)+vertOffset];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(7) = Line(startPoint, endPoint, tagPoint, 'left');

% min to maxR vert:
startPoint = [maxRX,minY];
endPoint = [maxRX,maxRY];
halfwayPoint = getHalfwayPoint(startPoint,endPoint);
tagPoint = [halfwayPoint(1)+horzOffset,halfwayPoint(2)];

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

[points] = checkForRoiOn(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

lines(8) = Line(startPoint, endPoint, tagPoint, 'right');

end

function [points] = checkForRoiOn(points, roiOn, roiCoords)
%checkForRoiOn corrects for roiOn if needed

if roiOn
    points = nonRoiToRoi(roiCoords, points);
end


end
