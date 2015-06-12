function [ handles ] = drawWaypoints(currentFile, handles, toggled, draggable)
%drawWaypoints updates the waypoints as needed

waypointHandles = handles.waypointHandles;

waypoints = currentFile.getWaypoints();
numWaypoints = length(waypoints);

if currentFile.waypointsOn
    if isempty(waypointHandles) %create new
        %constants
        colour = Constants.WAYPOINT_COLOUR;
        
        %create waypoints
        
        waypointHandles = impoint.empty(numWaypoints, 0); %empty handle matrix
        
        for i=1:numWaypoints            
            waypointHandles(i) = plotImpoint(waypoints(i,:), colour, draggable, handles.imageAxes);
        end
        
        % push up update
        handles.waypointHandles = waypointHandles;
    else %handles not empty, the elements already exist, so just update
        if toggled %just set visiblity
            for i=1:numWaypoints
                set(waypointHandles(i),'Visible','on');
            end
        end
        
        %update them
        for i=1:numWaypoints
            setPosition(waypointHandles(i), waypoints(i,:));
        end
    end
else %turn it off
    if ~isempty(waypointHandles) %if the objects exist, turn them off
        for i=1:numWaypoints
            set(waypointHandles(i),'Visible','off');
        end
    end
end

end

