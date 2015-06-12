function points = confirmNonRoi(points, roiOn, roiCoords)
%confirmNonRoi if not in non roi coords, gets it there

if roiOn
    points = roiToNonRoi(roiCoords, points);
end

end

