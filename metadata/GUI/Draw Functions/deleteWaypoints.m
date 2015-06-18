function [ handles ] = deleteWaypoints( handles )
%deleteWaypoints deletes the all the handles associated with the waypoints. Updates
%handles to reflect this

waypointHandles = handles.waypointHandles;

for i=1:length(waypointHandles)
    delete(waypointHandles(i));
end

handles.waypointHandles = impoint.empty;

end

