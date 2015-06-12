function [midlineHandle] = showCurrentMidline( file, imageDisplayHandle )
%getCurrentImage given the file, it displays the selected image type
%(original, ROI, etc.)

axes(imageDisplayHandle);

midlineHandle = [];

if file.midlineOn && ~isempty(file.midlinePoints)
    midlinePoints = checkForRoiOn(file.midlinePoints, file.roiOn, file.roiCoords);
    
    midlineHandle = plotMidlinePoints(midlinePoints, imageDisplayHandle);

end

end

