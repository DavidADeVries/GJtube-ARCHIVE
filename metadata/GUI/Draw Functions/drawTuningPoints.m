function [ handles ] = drawTuningPoints(currentFile, handles)
%drawTuningPoints draws the tuning points to augment the tube's position

origTubePoints = currentFile.tubePoints;
tubePoints = currentFile.getTubePoints(); %adjusted for ROI
waypointPassbys = currentFile.getWaypointPassbys();

% constants
spacing = Constants.TUNING_POINT_SPACING; %how often tuning points are placed

startColour = Constants.TUNING_POINT_START_COLOUR;
endColour = Constants.TUNING_POINT_END_COLOUR;

draggable = true;

%plot the tuning points!

spaceNumber = 2;

tuningPoints = cell(0);
tuningPointNum = 1;

numTuningPoints = floor(length(tubePoints) / spacing);

% calculate colour increments for gradient colour shift between
% lines
redShift = (endColour(1) - startColour(1))/numTuningPoints;
greenShift = (endColour(2) - startColour(2))/numTuningPoints;
blueShift = (endColour(3) - startColour(3))/numTuningPoints;

for i=1:length(tubePoints)    

    if isequal(tubePoints(i,:), waypointPassbys(spaceNumber - 1, :))
        spaceNumber = spaceNumber + 1;
    end

    if mod(i, spacing) == 0        
        r = startColour(1) + (i/spacing)*redShift;
        g = startColour(2) + (i/spacing)*greenShift;
        b = startColour(3) + (i/spacing)*blueShift;
        
        colour = [r g b];
                
        handle = plotImpoint(tubePoints(i,:), colour, draggable, handles.imageAxes);           

        tuningPoints{tuningPointNum} = TuningPoint(handle, spaceNumber, origTubePoints(i,:)); %store original position with ROI coord shift
        tuningPointNum = tuningPointNum + 1;
    end
end

end
