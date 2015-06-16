classdef File
    %file represents an open DICOM file
    
    properties
        dicomInfo
        image
        roiCoords = [];
        originalLimits
        contrastLimits = [];
        date % I know dicomInfo would hold this, but to have it lin an easily compared form is nice

        roiOn = false;
        contrastOn = false;
        waypointsOn = false;
        tubeOn = false;
        refOn = false;
        midlineOn = false;
        metricsOn = false;
        quickMeasureOn = false;
        displayUnits = ''; %can be: none, absolute, relative, pixel
        
        waypoints = [];
        waypointPassbys = []; %records which points in the tubePoints were the first point past a waypoint
        tubePoints = [];
        refPoints = [];
        midlinePoints = [];
        metricPoints = [];%extrema/metric points are kept in the order [maxL; min; maxR]
        quickMeasurePoints = [];
        
        longitudinalOverlayOn = true; %whether or not it will be included in a longitudinal comparison view
        
        undoCache = UndoCache.empty;
    end
    
    methods
        %% Constructor %%
        function file = File(dicomInfo, dicomImage, originalLimits)
            file.dicomInfo = dicomInfo;
            file.image = dicomImage;
            file.originalLimits = originalLimits;
            file.date = Date(dicomInfo.AcquisitionDate);
            
            file.undoCache = UndoCache(file);
        end
        
        %% setWaypoints %%
        % sets points, transforming points in non-ROI coords
        function file = setWaypoints(file, waypoints)
            file.waypoints = confirmNonRoi(waypoints, file.roiOn, file.roiCoords);
        end
        
        %% getWaypoints %%
        % gets points adjusting for ROI being on or not
        function waypoints = getWaypoints(file)
            waypoints = confirmMatchRoi(file.waypoints, file.roiOn, file.roiCoords);
        end
        
        %% setTubePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setTubePoints(file, tubePoints)
            file.tubePoints = confirmNonRoi(tubePoints, file.roiOn, file.roiCoords);
        end
        
        %% getTubePoints %%
        % gets points adjusting for ROI being on or not
        function tubePoints = getTubePoints(file)
            tubePoints = confirmMatchRoi(file.tubePoints, file.roiOn, file.roiCoords);
        end
        
        %% setWaypointPassbys %%
        % sets points, transforming points in non-ROI coords
        function file = setWaypointPassbys(file, waypointPassbys)
            file.waypointPassbys = confirmNonRoi(waypointPassbys, file.roiOn, file.roiCoords);
        end
        
        %% getWaypointPassbys %%
        % gets points adjusting for ROI being on or not
        function waypointPassbys = getWaypointPassbys(file)
            waypointPassbys = confirmMatchRoi(file.waypointPassbys, file.roiOn, file.roiCoords);
        end
        
        %% setRefPoints %%
        % sets points, transforming points in non-ROI coords
        function file = setRefPoints(file, refPoints)
            file.refPoints = confirmNonRoi(refPoints, file.roiOn, file.roiCoords);
        end
        
        %% getRefPoints %%
        % gets points adjusting for ROI being on or not
        function refPoints = getRefPoints(file)
            refPoints = confirmMatchRoi(file.refPoints, file.roiOn, file.roiCoords);
        end
        
        %% setMidlinePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setMidlinePoints(file, midlinePoints)
            file.midlinePoints = confirmNonRoi(midlinePoints, file.roiOn, file.roiCoords);
        end
        
        %% getMidlinePoints %%
        % gets points adjusting for ROI being on or not
        function midlinePoints = getMidlinePoints(file)
            midlinePoints = confirmMatchRoi(file.midlinePoints, file.roiOn, file.roiCoords);
        end
        
        %% setMetricPoints %%
        % sets points, transforming points in non-ROI coords
        function file = setMetricPoints(file, metricPoints)
            file.metricPoints = confirmNonRoi(metricPoints, file.roiOn, file.roiCoords);
        end
        
        %% getMetricPoints %%
        % gets points adjusting for ROI being on or not
        function metricPoints = getMetricPoints(file)
            metricPoints = confirmMatchRoi(file.metricPoints, file.roiOn, file.roiCoords);
        end
        
        %% setQuickMeasurePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setQuickMeasurePoints(file, quickMeasurePoints)
            file.quickMeasurePoints = confirmNonRoi(quickMeasurePoints, file.roiOn, file.roiCoords);
        end
        
        %% getQuickMeasurePoints %%
        % gets points adjusting for ROI being on or not
        function quickMeasurePoints = getQuickMeasurePoints(file)
            quickMeasurePoints = confirmMatchRoi(file.quickMeasurePoints, file.roiOn, file.roiCoords);
        end
        
        %% chooseDisplayUnits %%
        % sets the file's displayUnits field if not yet set
        function file = chooseDisplayUnits(file)
            if isempty(file.displayUnits) %only change if not yet defined
                % putting it in the reference units is preferred, but if not, pixels it is, boys, pixels it is
                if isempty(file.refPoints)
                    file.displayUnits = 'pixel';
                else
                    file.displayUnits = 'relative';
                end
            end
        end
        
        %% getUnitConversion %%
        %returns the unitString (px, mm, etc.) and the unitConversion
        %factor, in the form [xScalingFactor, yScalingFactor]
        %to convert take value in px and multiply by scaling factor
        function [ unitString, unitConversion ] = getUnitConversion(file)
            %getUnitConversions gives back a string for display purposes, as well as a
            %coefficient such that pixelMeaurement*coeff = measurementInUnits
            
            switch file.displayUnits
                case 'none'
                    unitString = '';
                    unitConversion = [];
                case 'relative'
                    unitString = 'u';
                    conversionFactor = 1 / norm(file.refPoints(1,:) - file.refPoints(2,:));
                    
                    unitConversion = [conversionFactor, conversionFactor];
                case 'absolute'
                    unitString = 'mm';
                    
                    sourceToDetector = file.dicomInfo.DistanceSourceToDetector;
                    sourceToPatient = file.dicomInfo.DistanceSourceToPatient;
                    
                    magFactor = sourceToDetector / sourceToPatient;
                    
                    pixelSpacing = file.dicomInfo.ImagerPixelSpacing;
                    
                    unitConversion = pixelSpacing / magFactor; %NOTE: THIS CAN ONLY BE A ROUGH ESTIMATE DUE TO THE PROPERITIES OF PROJECTION IMAGING!!!
                case 'pixel'
                    unitString = 'px';
                    unitConversion = [1,1]; %everything is stored in px measurements,so no conversion neeeded.
            end
        end
        
        %% getCurrentLimits %%
        % returns the current contrast limits
        function [ cLim ] = getCurrentLimits(obj)
            %getCurrentLimits returns cLims dependent on whether contrast is set or not
            
            if obj.contrastOn
                cLim = obj.contrastLimits;
            else
                cLim = obj.originalLimits;
            end
            
        end
        
        %% getCurrentImage %%
        % returns cropped imaged or not
        function [ image ] = getCurrentImage(obj)
            %getCurrentImage returns the current image for the file (entire or ROI)
            
            if obj.roiOn
                image = imcrop(obj.image, obj.roiCoords);
            else
                image = obj.image;
            end           
        end
        
        %% getAdjustedImage %%
        % applies contrast limits to actual image values
        function [ adjImage ] = getAdjustedImage(obj)
            %getAdjustedImage returns image matrix with contrast applied, if required
            
            adjImage = getCurrentImage(obj);
            
            if obj.contrastOn
                dims = size(adjImage);
                
                contrastLim = obj.contrastLimits;
                
                for i=1:dims(1)
                    for j=1:dims(2)
                        if adjImage(i,j) < contrastLim(1) %basic contrast implementation (no gamma)
                            adjImage(i,j) = contrastLim(1);
                        elseif adjImage(i,j) > contrastLim(2)
                            adjImage(i,j) = contrastLim(2);
                        end
                    end
                end
            end
            
        end
        
        %% isValid %%
        function [isValid] = isValidForLongitudinal(file)
            %returns if the file is valid to be used in a longitudinal
            %comparison (must have certain points set)
            
            hasTube = ~isempty(file.tubePoints);
            hasReference = ~isempty(file.refPoints);
            hasMetricPoints = ~isempty(file.metricPoints);
            
            isValid = hasTube && hasReference && hasMetricPoints;
        end
        
        %% setNewWaypoints %%
        function [ file ] = setNewWaypoints(file, tuningPoints, waypointHandles)
            %by looking at shifts in the tuning points, a new set of
            %waypoints is created
            
            % first the original waypoints themselves
            
%             numWaypoints = length(waypointHandles);
%             
%             newPositions = zeros(numWaypoints, 2);
%             
%             for i=1:numWaypoints
%                 newPositions(i,:) = getPosition(waypointHandles(i));
%             end
%             
%             file = file.setWaypoints(newPositions);
            
            %now add in the new ones
                        
            numTuningPoints = length(tuningPoints);
            
            newWaypoints = [];
            
            newWaypoints(1,:) = getPosition(waypointHandles(1)); %first two waypoints remain the same
            newWaypoints(2,:) = getPosition(waypointHandles(2));
            
            spaceNum = 2; %start at space 2 (space 1 is between the first 2 waypoints)
            tuningPointNum = 1;
            oldWaypointNum = 3;
            newWaypointNum = 3;
            
            while oldWaypointNum <= length(waypointHandles)
                if tuningPointNum > numTuningPoints
                    newWaypoints(newWaypointNum,:) = getPosition(waypointHandles(oldWaypointNum));%oldWaypoints(oldWaypointNum,:);
                    
                    newWaypointNum = newWaypointNum + 1;
                    oldWaypointNum = oldWaypointNum + 1;
                elseif tuningPoints(tuningPointNum).spaceNumber > spaceNum
                    newWaypoints(newWaypointNum,:) = getPosition(waypointHandles(oldWaypointNum));%oldWaypoints(oldWaypointNum,:);
                    
                    oldWaypointNum = oldWaypointNum + 1;
                    newWaypointNum = newWaypointNum + 1;
                    spaceNum = spaceNum + 1;
                else
                    currentTuningPointPos = getPosition(tuningPoints(tuningPointNum).handle);          
                    
                    if isequal(currentTuningPointPos, tuningPoints(tuningPointNum).getOriginalPosition(file)) %point has moved, so not being used
                        tuningPointNum = tuningPointNum + 1;
                    else
                        newWaypoints(newWaypointNum,:) = currentTuningPointPos(1,:);
                        
                        newWaypointNum = newWaypointNum + 1;
                        tuningPointNum = tuningPointNum + 1;
                    end
                end
            end
            
            file = file.setWaypoints(newWaypoints);
        end
        
        %% updateUndoCache %%
        % saves the file at current into its own undo cache
        function [ file ] = updateUndoCache( file )
            %updateUndoCache takes whatever is in the currentFile that could be changed
            %and caches it
            
            cache = file.undoCache;
            
            oldCacheEntries = cache.cacheEntries;
            
            newCacheSize = cache.numCacheEntries()  - cache.cacheLocation + 2;
            
            maxCacheSize = cache.cacheSize;
            
            if newCacheSize > maxCacheSize
                newCacheSize = maxCacheSize;
            end
            
            newCacheEntries = CacheEntry.empty(newCacheSize,0);
            
            newCacheEntries(1) = CacheEntry(file); %most recent is now the current state (all previous redo options eliminated)
            
            %bring in all entries that are still in the "past". Any before
            %cacheLocation are technically in a "future" that since a change has been
            %made, it would be inconsistent for this "future" to be reachable, and so
            %the entries are removed.
            
            for i=2:newCacheSize
                newCacheEntries(i) = oldCacheEntries(cache.cacheLocation + i - 2);
            end
            
            cache.cacheEntries = newCacheEntries;
            cache.cacheLocation = 1;
            
            file.undoCache = cache;            
        end
        
        
        %% performUndo %%
        function [ file ] = performUndo( file )
            %performUndo actually what it says on the tin
            
            cacheLocation = file.undoCache.cacheLocation;
            
            numCacheEntries = length(file.undoCache.cacheEntries);
            
            cacheLocation = cacheLocation + 1; %go back in time
            
            if cacheLocation > numCacheEntries
                cacheLocation = numCacheEntries;
            end
            
            if cacheLocation > file.undoCache.cacheSize
                cacheLocation = file.undoCache.cacheSize;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file);           
        end
        
        %% performRedo %%
        function [ file ] = performRedo( file )
            %performUndo actually what it says on the tin
                        
            cacheLocation = file.undoCache.cacheLocation;
            
            cacheLocation = cacheLocation - 1; %go forward in time
            
            if  cacheLocation == 0
                cacheLocation = 1;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file); 
        end
        
        %% getMeasurements %%
        function [measurements] = getMeasurements(file)
            %returns the measurements needed to be outputted for analysis
            %results stored in struct
            A = 54.2;
            B= 12.9;
            
            measurements = struct('A',A,'B',B);
        end

    end
    
end

