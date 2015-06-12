function [quickMeasureHandle] = showCurrentQuickMeasure( file, imageDisplayHandle )
%getCurrentImage given the file, it displays the selected image type
%(original, ROI, etc.)

axes(imageDisplayHandle);

quickMeasureHandle = [];

if file.quickMeasureOn && ~isempty(file.quickMeasurePoints)
    quickMeasurePoints = checkForRoiOn(file.quickMeasurePoints, file.roiOn, file.roiCoords);
    
    vertOffset = 5;
    
    halfwayPoint = getHalfwayPoint(quickMeasurePoints(1,:), quickMeasurePoints(2,:));
    tagPoint = [halfwayPoint(1),halfwayPoint(2)+vertOffset];
    
    line = Line(quickMeasurePoints(1,:), quickMeasurePoints(2,:), tagPoint, 'left');
    
    [ unitString, unitConversion ] = file.getUnitConversion();
    
    line = setTagStrings(line, unitString, unitConversion);
    
    quickMeasureHandle = plotQuickMeasurePoints(line, imageDisplayHandle);

end

end

