function [ shift, scale, angleShift, angle ] = getTransformParams(basePoints, transPoints)
%getTransformParams given a base set of points and a second set of
%points, the shifts, scale and rotation is given in order to get the points
%aligned with the base points. Rotation will be based around the
%bottom point 

%first get bottom and top points figured out
if basePoints(1,2) < basePoints(2,2)
    bottomBasePoint = basePoints(1,:);
    topBasePoint = basePoints(2,:);
else
    bottomBasePoint = basePoints(2,:);
    topBasePoint = basePoints(1,:);
end

if transPoints(1,2) < transPoints(2,2)
    bottomTransPoint = transPoints(1,:);
    topTransPoint = transPoints(2,:);
else
    bottomTransPoint = transPoints(2,:);
    topTransPoint = transPoints(1,:);
end

%shifts
x = bottomBasePoint(1) - bottomTransPoint(1);
y = bottomBasePoint(2) - bottomTransPoint(2);

shift = [x,y];

%scale

baseLength = norm(topBasePoint - bottomBasePoint);
transLength = norm(topTransPoint - bottomTransPoint);

scale = baseLength/transLength; %we assume the horz/vert scaling is the same

%angle
baseAngle = atand((topBasePoint(1) - bottomBasePoint(1)) / (topBasePoint(2) - bottomBasePoint(2)));
transAngle = atand((topTransPoint(1) - bottomTransPoint(1)) / (topTransPoint(2) - bottomTransPoint(2)));

angle = transAngle - baseAngle;

angleShift = -bottomBasePoint; %want rotation to occur around bottom point

end

