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

pylorusPoint = applyRotationMatrix(metricPoints.pylorusPoint, rotMatrix);
pointA = applyRotationMatrix(metricPoints.pointA, rotMatrix);
pointB = applyRotationMatrix(metricPoints.pointB, rotMatrix);
pointC = applyRotationMatrix(metricPoints.pointC, rotMatrix);
pointD = applyRotationMatrix(metricPoints.pointD, rotMatrix);

%rotMidlinePoints = applyRotationMatrix(midlinePoints, rotMatrix);

% create the lines
lines = Line.empty(6,0);

%offsets so that labels don't lie directly on lines
vertOffset = -5; %px
horzOffset = +3; %px

% % find lines % %
isBridge = false; %all these are actual measurement lines, not bridge reference lines

% % line a % %
startPoint = pointD;
endPoint = [pylorusPoint(1), pointD(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'a = ';
lines(1) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % line b % %
startPoint = pointA;
endPoint = [pointA(1), pointC(2)];

tagPoint = [endPoint(1)+horzOffset, endPoint(2)-20]; %didn't want this way halfway, it hit another line. Just a touch above the bottom point

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'b = ';
lines(2) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % line c % %
startPoint = pointB;
endPoint = [pointD(1), pointB(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'c = ';
lines(3) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % line d % %
startPoint = pylorusPoint;
endPoint = [pylorusPoint(1), pointD(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1)+horzOffset, halfwayPoint(2)];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'd = ';
lines(4) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % find bridges % %
isBridge = true; %these are just reference lines for the measurment lines, such that their ends are floating in space

% % bridge for line b % %
startPoint = pointC;
endPoint = [pointA(1), pointC(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(5) = Line(startPoint, endPoint, tagPoint, 'left', isBridge);

% % bridge for line c % %
startPoint = pointD;
endPoint = [pointD(1), pointB(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1)+horzOffset, halfwayPoint(2)];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(6) = Line(startPoint, endPoint, tagPoint, 'right', isBridge);

end

function [startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords)
%transformForDisplay
%rotates make into normal coords and applys ROI transform if needed

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);
points = confirmMatchRoi(points, roiOn, roiCoords);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

end
