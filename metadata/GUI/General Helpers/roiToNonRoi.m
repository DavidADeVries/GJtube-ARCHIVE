function [ transformedPoints ] = roiToNonRoi( roiCoords, points)
%roiToNonRoi takes points that were collected in the ROI view and
%transforms them so that they will fit in a non-ROI view
%expects points in numPoints x 2 matrix

dims = size(points);

xmin = roiCoords(1);
ymin = roiCoords(2);

transformedPoints = zeros(dims);

for i=1:dims(1) %run through points
    point = points(i,:);
    
    transformedPoints(i,:) = [(point(1) + xmin), (point(2) + ymin)];
end


end

