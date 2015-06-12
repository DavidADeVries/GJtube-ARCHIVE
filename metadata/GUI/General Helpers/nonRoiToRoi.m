function [ transformedPoints ] = nonRoiToRoi( roiCoords, points)
%nonRoiToRoi takes points that were collected in the non-ROI view and
%transforms them so that they will fit in a ROI view
%expects points in numPoints x 2 matrix

dims = size(points);

xmin = roiCoords(1);
ymin = roiCoords(2);
width = roiCoords(3);
height = roiCoords(4);

transformedPoints = [];

numTransPoints = 0;

for i=1:dims(1) %run through points
    point = points(i,:);
    
    if point(1) >= xmin && point(1) <= xmin + width && point(2) >= ymin && point(2) <= ymin + height
        numTransPoints = numTransPoints + 1;
        
        transformedPoints(numTransPoints,1:2) = [(point(1) - xmin), (point(2) - ymin)]; %TODO preallocate
    end        
end


end

