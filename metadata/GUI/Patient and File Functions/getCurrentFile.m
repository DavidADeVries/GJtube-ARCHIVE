function [ currentFile ] = getCurrentFile( handles )
%getCurrentFile gets the current file from the current patient

currentPatient = getCurrentPatient(handles);

if isempty(currentPatient)
    currentFile = File.empty;
else
    currentFile = currentPatient.getCurrentFile();
end

end

