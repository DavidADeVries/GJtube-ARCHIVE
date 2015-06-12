function [ waypoints ] = updatePositionsOfWaypoints(file)
%updatePositionsOfWaypoints when waypoints are being tuned, in addition to
%adding new waypoints, the original waypoints can be dragged. This function
%finds these waypoints via their handles and saves their position

waypoints = file.waypoints;

for i=1:length(waypoints);
    position = getPosition(waypoints(i).handle);

    if file.roiOn
        position = roiToNonRoi(file.roiCoords, position);
    end

    waypoints(i).point = position;
end


end

