function [metricPointHandles] = showCurrentMetricPoints( file, imageDisplayHandle )
%getCurrentImage given the file, it displays the selected image type
%(original, ROI, etc.)

axes(imageDisplayHandle);

metricPointHandles = [];

if file.metricsOn && ~isempty(file.metricPoints)
    metricPoints = checkForRoiOn(file.metricPoints, file.roiOn, file.roiCoords);
    
    [metricPointHandles] = plotMetricPoints(metricPoints, imageDisplayHandle);

end

end

