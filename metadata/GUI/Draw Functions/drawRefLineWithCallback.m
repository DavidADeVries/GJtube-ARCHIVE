function [ handles ] = drawRefLineWithCallback(currentFile, handles, hObject, toggled)
%drawRefLineWithCallback draws the reference line as well as puts the
%callback together to save points as it is clicked and dragged

refLineHandle = handles.refLineHandle;

refPoints = currentFile.getRefPoints();

if currentFile.refOn
    if isempty(refLineHandle)%create new
        %constants
        colour = Constants.REFERENCE_LINE_COLOUR;
        
        % draw line
        refLineHandle = imline(handles.imageAxes, refPoints(:,1), refPoints(:,2));
        setColor(refLineHandle, colour);
        
        % add callback for click and drag action
        func = @(pos) saveRefLinePoints(hObject);
        addNewPositionCallback(refLineHandle, func);
        
        % push up update
        handles.refLineHandle = refLineHandle;
    else %handles not empty, the elements already exist, so just update
        if toggled %just set visiblity
            set(refLineHandle, 'Visible', 'on');
        end
        
        %update them
        setPosition(refLineHandle, refPoints(:,1), refPoints(:,2));
    end
else %turn it off
    if ~isempty(refLineHandle)%if the objects exist, turn them off
        set(refLineHandle, 'Visible', 'off');
    end
end

end

