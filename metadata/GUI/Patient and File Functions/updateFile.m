function [ handles ] = updateFile( file, updateUndo, pendingChanges, handles, varargin)
%updateFile pushes up the changes done to a file

currentPatient = getCurrentPatient(handles);

if length(varargin) == 1 %file num is specified! Not currentFile!
    fileNum = varargin{1};
    
    currentPatient = currentPatient.updateFile(file, updateUndo, pendingChanges, fileNum);
else
    currentPatient = currentPatient.updateFile(file, updateUndo, pendingChanges);
end

handles = updatePatient(currentPatient, handles);

end

