classdef Waypoint
    %Waypoint the points that give a rough estimation of the tube which the
    %segmentation takes into account. A class is needed to encompass the
    %handle and actually value of the waypoint.
    
    properties
        handle
        point
    end
    
    methods
        function waypoint = Waypoint(point, roiOn, roiCoords)
            if roiOn
                point = roiToNonRoi(roiCoords, point);
            end
            
            waypoint.handle = [];
            waypoint.point = point;
        end
    end
    
end

