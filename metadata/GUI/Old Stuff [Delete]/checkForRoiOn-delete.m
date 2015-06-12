function [points] = checkForRoiOn-delete(points, roiOn, roiCoords)
%checkForRoiOn corrects for roiOn if needed

if roiOn
    points = nonRoiToRoi(roiCoords, points);
end


end

