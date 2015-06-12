function [ handles ] = drawMidlineWithCallback(currentFile, handles, hObject, toggled)
%drawMidlineWithCallback draws the midline as well as puts the
%callback together to save points as it is clicked and dragged

midlineHandle = handles.midlineHandle;

midlinePoints = currentFile.getMidlinePoints();

if currentFile.midlineOn
    if isempty(midlineHandle) %create new
        % constants
        colour = Constants.MIDLINE_COLOUR;
        
        % draw line
        midlineHandle = imline(handles.imageAxes, midlinePoints(:,1), midlinePoints(:,2));
        setColor(midlineHandle, colour);
        
        % add callback for click and drag action!
        func = @(pos) saveMidlinePoints(hObject);
        addNewPositionCallback(midlineHandle, func);
        
        % push up update
        handles.midlineHandle = midlineHandle;
    else %handles not empty, the elements already exist, so just update
        if toggled %set visiblity
            set(midlineHandle, 'Visible', 'on');
        end
        
        %update them
        setPosition(midlineHandle, midlinePoints(:,1), midlinePoints(:,2));
    end
else %turn it off
    if ~isempty(midlineHandle) %if the objects exist, turn them off
        set(midlineHandle, 'Visible', 'off');
    end
end

end

