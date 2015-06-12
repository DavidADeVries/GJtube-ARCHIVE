classdef TuningPoint
    %TuningPoint a point that may become a new waypoint if the user drags
    %it to a new position
    
    properties
        handle
        spaceNumber %describes between which waypoints the tuning point acts (between first and second waypoint is space 1, etc.)
        originalPosition %used to compare against to see if point has been dragged. Stored in non-ROI coords!
    end
    
    methods
        %% Constructor %%
        function tuningPoint = TuningPoint(handle, spaceNumber, originalPosition, file)
            tuningPoint.handle = handle;
            tuningPoint.spaceNumber = spaceNumber;
            tuningPoint = tuningPoint.setOriginalPosition(originalPosition, file);
        end
        
        %% setOriginalPosition %%
        % sets points, transforming points in non-ROI coords
        function tuningPoint = setOriginalPosition(tuningPoint, originalPosition, file)
            tuningPoint.originalPosition = confirmNonRoi(originalPosition, file.roiOn, file.roiCoords);
        end
        
        %% getOriginalPosition %%
        % gets points adjusting for ROI being on or not
        function originalPosition = getOriginalPosition(tuningPoint, file)
            originalPosition = confirmMatchRoi(tuningPoint.originalPosition, file.roiOn, file.roiCoords);
        end
    end
    
end

