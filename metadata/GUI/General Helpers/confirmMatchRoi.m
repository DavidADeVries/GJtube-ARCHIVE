function [ points ] = confirmMatchRoi(points, roiOn, roiCoords)
%confirmMatchRoi points are stored in non-ROI coords. This function maps
%points to ROI coords if the ROI is on, otherwise leaves them alone

if roiOn
    points = nonRoiToRoi(roiCoords, points);
end


end

