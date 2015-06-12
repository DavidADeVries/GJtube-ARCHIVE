function [ waypoints ] = updateWaypoints( waypoints, imageDisplayHandle, draggable, roiOn, roiCoords)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(waypoints)
   delete(waypoints(i).handle); 
end

waypoints = plotWaypoints(waypoints, imageDisplayHandle, draggable, roiOn, roiCoords);

end

