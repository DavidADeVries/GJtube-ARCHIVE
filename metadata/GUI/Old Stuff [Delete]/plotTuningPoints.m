function [ tuningPoints ] = plotTuningPoints( file, imageDisplayHandle )
%plotTuningPoints plots impoints that can be clicked and dragged to make
%corrections

origTubePoints = file.tubePoints;
tubePoints = checkForRoiOn(file.tubePoints, file.roiOn, file.roiCoords);
waypointPassbys = checkForRoiOn(file.waypointPassbys, file.roiOn, file.roiCoords);

spacing = 10; %how often tuning points are placed

spaceNumber = 2;

tuningPoints = cell(0);
tuningPointNum = 1;

numTuningPoints = floor(length(tubePoints) / spacing);

colorStep = 1/numTuningPoints; %color will change incrementally

for i=1:length(tubePoints)    

    if isequal(tubePoints(i,:), waypointPassbys(spaceNumber - 1, :))
        spaceNumber = spaceNumber + 1;
    end

    if mod(i, spacing) == 0
        handle = impoint(imageDisplayHandle, tubePoints(i,:));
        
        setColor(handle, [0.5+tuningPointNum*(colorStep/2), tuningPointNum*(colorStep/2), 0]);            

        tuningPoints{tuningPointNum} = TuningPoint(handle, spaceNumber, origTubePoints(i,:)); %store original position with ROI coord shift
        tuningPointNum = tuningPointNum + 1;
    end
end

end

