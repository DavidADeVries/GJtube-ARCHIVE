function [ handles ] = deleteRefLine( handles )
%deleteRefLine deletes the all the handles associated with the ref line. Updates
%handles to reflect this

refLineHandle = handles.refLineHandle;

if ~isempty(refLineHandle)
    delete(refLineHandle);
end

handles.refLineHandle = imline.empty;

end

