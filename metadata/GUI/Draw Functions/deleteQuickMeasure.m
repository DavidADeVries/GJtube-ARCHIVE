function [ handles ] = deleteQuickMeasure( handles )
%deleteQuickMeasure deletes the all the handles associated with the quick measure. Updates
%handles to reflect this

lineHandle = handles.quickMeasureLineHandle;
textLabel = handles.quickMeasureTextLabel;

if ~isempty(lineHandle)
    delete(lineHandle);
end

if ~isempty(textLabel)
   textLabel.delete(); 
end

handles.quickMeasureLineHandle = imline.empty;
handles.quickMeasureTextLabel = TextLabel.empty;

end

