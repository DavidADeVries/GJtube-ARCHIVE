function [ angle ] = findCorrectionAngle( midlinePoints )
%findCorrectionAngle given the points defining the midline, the amount to
%rotate the image to be vertically aligned is given

if midlinePoints(1,2) > midlinePoints(2,2)
    topPoint = midlinePoints(2,:);
    bottomPoint = midlinePoints(1,:);
else
    topPoint = midlinePoints(1,:);
    bottomPoint = midlinePoints(2,:);
end

angle = atand((bottomPoint(1)-topPoint(1))/(bottomPoint(2)-topPoint(2)));

end

