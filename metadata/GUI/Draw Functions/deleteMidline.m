function [ handles ] = deleteMidline( handles )
%deleteMidline deletes the all the handles associated with the midline. Updates
%handles to reflect this

midlineHandle = handles.midlineHandle;

if ~isempty(midlineHandle)
    delete(midlineHandle);
end

handles.midlineHandle = imline.empty;

end

