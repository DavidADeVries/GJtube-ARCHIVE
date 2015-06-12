function [ handles ] = deleteObjects(handles)
%deleteObjects deletes the objects given

for i=1:length(handles)
    delete(handles(i));
end

handles = gobjects(0);

end

