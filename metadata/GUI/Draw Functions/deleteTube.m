function [ handles ] = deleteTube( handles )
%deleteTube deletes the all the handles associated with the tube. Updates
%handles to reflect this

displayTube = handles.displayTube;

if ~isempty(displayTube)
    displayTube.delete();
end

handles.displayTube = DisplayTube.empty;

end

