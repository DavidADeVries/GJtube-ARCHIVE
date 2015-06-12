function [ handles ] = drawTube(currentFile, handles, toggled)
%drawTube draws the segmented Tube, as needed

displayTube = handles.displayTube;

tubePoints = currentFile.getTubePoints();

if currentFile.tubeOn
    if isempty(displayTube) %create new
        %constants
        style = Constants.TUBE_STYLE;
        baseColour = Constants.TUBE_BASE_COLOUR;
        borderColour = Constants.TUBE_BORDER_COLOUR;
        lineWidth = Constants.TUBE_WIDTH;
        borderWidth = Constants.TUBE_BORDER_WIDTH;
        
        % plots tube and create DisplayTube object
        handles.displayTube = DisplayTube(tubePoints, style, lineWidth, borderWidth, borderColour, baseColour);
    else %handles not empty, the elements already exist, so just update
        if toggled %just set visiblity
            displayTube.setVisible('on');
        end
        
        %update them
        displayTube.update(tubePoints);
    end
else %turn it off
    if ~isempty(displayTube) %if the objects exist, turn them off
        displayTube.setVisible('off');
    end
end

end

