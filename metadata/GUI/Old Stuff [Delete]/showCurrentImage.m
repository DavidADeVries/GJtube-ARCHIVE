function [plotHandles, waypoints] = showCurrentImage( file, imageDisplayHandle )
%getCurrentImage given the file, it displays the selected image type
%(original, ROI, etc.)

plotHandles = [];
waypoints = [];

if ~isempty(file)
    image = getCurrentImage(file);
    
    cLim = getCurrentLimits(file);
    
    axes(imageDisplayHandle);
    
    imageHandle = imshow(image,cLim);
    
    plotHandles = struct('imageHandle',imageHandle,'arrowHandles',[],'textHandles',[],'waypointHandles',[]);
    
    waypoints = file.waypoints;
    
    if file.tubeOn
        tubePoints = checkForRoiOn(file.tubePoints, file.roiOn, file.roiCoords);
        
        baseColor = [0,0.5,1];
        
        plotTubePoints(tubePoints, 'line', baseColor);
    end
    
    if file.waypointsOn
        draggable = false; %only want these points moving when we tune the line
        
        waypoints = plotWaypoints(file.waypoints, imageDisplayHandle, draggable, file.roiOn, file.roiCoords);
    end
    
    if file.metricsOn
        metricLines = calcMetricLines(file.midlinePoints, file.metricPoints, file.roiOn, file.roiCoords);
        
        [unitString, unitConversion] = getUnitConversion(file);
        
        metricLines = setTagStrings(metricLines, unitString, unitConversion);
        
        [arrowHandles, textHandles] = plotMetricLines(metricLines);
        
        plotHandles.arrowHandles = arrowHandles;
        plotHandles.textHandles = textHandles;
    end
end


end

