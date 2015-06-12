function [ handles ] = drawTuningPoints(currentFile, handles)
%drawTuningPoints draws the tuning points to augment the tube's position

tubePoints = currentFile.getTubePoints(); %adjusted for ROI
waypointPassbys = currentFile.getWaypointPassbys();

% constants
spacing = Constants.TUNING_POINT_SPACING; %how often tuning points are placed

startColour = Constants.TUNING_POINT_START_COLOUR;
endColour = Constants.TUNING_POINT_END_COLOUR;

draggable = true;

%plot the tuning points!

spaceNumber = 2;


tuningPointNum = 1;

numTuningPoints = floor(length(tubePoints) / spacing);

tuningPoints = TuningPoint.empty(numTuningPoints, 0);

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
        r = startColour(1) + tuningPointNum*redShift;
        g = startColour(2) + tuningPointNum*greenShift;
        b = startColour(3) + tuningPointNum*blueShift;
        
        colour = [r g b];
                
        handle = plotImpoint(tubePoints(i,:), colour, draggable, handles.imageAxes);           

        tuningPoints(tuningPointNum) = TuningPoint(handle, spaceNumber, tubePoints(i,:), currentFile); %store original position with ROI coord shift
        tuningPointNum = tuningPointNum + 1;
    end
end

handles.tuningPoints = tuningPoints;

end

