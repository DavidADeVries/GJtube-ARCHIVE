function [ halfwayPoint ] = getHalfwayPoint(startPoint, endPoint) 
%getHalfwayPoint returns the point halfway between the two points


x = startPoint(1) + (endPoint(1) - startPoint(1))/2;
y = startPoint(2) + (endPoint(2) - startPoint(2))/2;

halfwayPoint = [x,y];


end

