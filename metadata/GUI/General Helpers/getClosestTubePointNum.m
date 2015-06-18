function [ tubePointNum ] = getClosestTubePointNum( point, tubePoints )
%getClosestTubePointNum finds the closest tube point to the given point,
%and returns which index in the tube points the found closest tube point
%has

tubePointNum = 0;
closestDistance = Inf;

for i=1:length(tubePoints)
    distance = norm(tubePoints(i,:) - point);
    
    if distance < closestDistance
        closestDistance = distance;
        tubePointNum = i;
    end
end


end

