function [waypoints] = plotWaypoints( waypoints, imageDisplayHandle, draggable, roiOn, roiCoords )
%plotWaypoints plots waypoints 

for i=1:length(waypoints)
    point = waypoints(i).point;
    
    if roiOn
       point = nonRoiToRoi(roiCoords, point); 
    end
    
    handle = impoint(imageDisplayHandle, point(1), point(2));
    setColor(handle,'c');
        
    if ~draggable
        xLim = [point(1), point(1)];
        yLim = [point(2), point(2)];
    
        func = makeConstrainToRectFcn('impoint', xLim, yLim); %this constaint fn will keep point stationary    

        setPositionConstraintFcn(handle, func);
    end
    
    waypoints(i).handle = handle;
end


end

