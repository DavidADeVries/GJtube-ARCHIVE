function [ x,y ] = findXY( curPoint, angle, radius)
%findXY for a given point and a angle measured from x axis towards y axis
%(clockwise in MATLAB), ranging from 0 - 360, the point at that angle and
%radius is found

x = curPoint(1) + radius*cosd(angle);
y = curPoint(2) + radius*sind(angle);

end
