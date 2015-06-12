classdef TuningPoint
    %TuningPoint a point that may become a new waypoint if the user drags
    %it to a new position
    
    properties
        handle
        spaceNumber %describes between which waypoints the tuning point acts (between first and second waypoint is space 1, etc.)
        originalPosition %used to compare against to see if point has been dragged
    end
    
    methods
        function tuningPoint = TuningPoint(handle, spaceNumber, originalPosition)
            tuningPoint.handle = handle;
            tuningPoint.spaceNumber = spaceNumber;
            tuningPoint.originalPosition = originalPosition;
        end
    end
    
end

