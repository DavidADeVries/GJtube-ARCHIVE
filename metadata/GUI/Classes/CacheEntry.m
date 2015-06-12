classdef CacheEntry
    %CacheEntry stores the relevant fields from a File to allow an undo
    %command to be performed
    
    properties
        roiCoords
        contrastLimits
        
        roiOn
        contrastOn
        waypointsOn
        tubeOn
        refOn
        midlineOn
        metricsOn
        quickMeasureOn
        
        waypoints
        tubePoints
        refPoints
        midlinePoints
        metricPoints
        quickMeasurePoints
    end
    
    methods
        function cacheEntry = CacheEntry(file)
            cacheEntry.roiCoords = file.roiCoords;
            cacheEntry.contrastLimits = file.contrastLimits;
            
            cacheEntry.roiOn = file.roiOn;
            cacheEntry.contrastOn = file.contrastOn;
            cacheEntry.waypointsOn = file.waypointsOn;
            cacheEntry.tubeOn = file.tubeOn;
            cacheEntry.refOn = file.refOn;
            cacheEntry.midlineOn = file.midlineOn;
            cacheEntry.metricsOn = file.metricsOn;
            cacheEntry.quickMeasureOn = file.quickMeasureOn;
            
            cacheEntry.waypoints = file.waypoints;
            cacheEntry.tubePoints = file.tubePoints;
            cacheEntry.refPoints = file.refPoints;
            cacheEntry.midlinePoints = file.midlinePoints;
            cacheEntry.metricPoints = file.metricPoints;
            cacheEntry.quickMeasurePoints = file.quickMeasurePoints;
        end
        
        function file = restoreToFile(cacheEntry, file)
            file.roiCoords = cacheEntry.roiCoords;
            file.contrastLimits = cacheEntry.contrastLimits;
            
            file.roiOn = cacheEntry.roiOn;
            file.contrastOn = cacheEntry.contrastOn;
            file.waypointsOn = cacheEntry.waypointsOn;
            file.tubeOn = cacheEntry.tubeOn;
            file.refOn = cacheEntry.refOn;
            file.midlineOn = cacheEntry.midlineOn;
            file.metricsOn = cacheEntry.metricsOn;
            file.quickMeasureOn = cacheEntry.quickMeasureOn;
            
            file.waypoints = cacheEntry.waypoints;
            file.tubePoints = cacheEntry.tubePoints;
            file.refPoints = cacheEntry.refPoints;
            file.midlinePoints = cacheEntry.midlinePoints;
            file.metricPoints = cacheEntry.metricPoints;
            file.quickMeasurePoints = cacheEntry.quickMeasurePoints;
        end
    end
    
end