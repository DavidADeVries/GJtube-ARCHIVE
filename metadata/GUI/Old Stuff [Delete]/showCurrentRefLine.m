function [refLineHandle] = showCurrentRefLine( file, imageDisplayHandle )
%getCurrentImage given the file, it displays the selected image type
%(original, ROI, etc.)

axes(imageDisplayHandle);

refLineHandle = [];

if file.refOn && ~isempty(file.refPoints)
    refPoints = checkForRoiOn(file.refPoints, file.roiOn, file.roiCoords);
    
    refLineHandle = plotRefPoints(refPoints, imageDisplayHandle);

end

end

