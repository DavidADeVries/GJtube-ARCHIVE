function [ openingCancelled ] = overwritePatientDialog()
%overwritePatientDialog when opening a saved patient and than patient is
%already open, the user is asked if they want to overwrite the patient or
%not

openingCancelled = true;

question = 'The patient you are currently opening is already open in your workspace. Continuing will discard any unsaved changes of this patient. Do you wish to continue?';
            
overwrite = 'OK';
cancel = 'Cancel';

default = overwrite;

choice = questdlg(question, 'Patient Conflict', overwrite, cancel, default);

switch choice
    case overwrite
        openingCancelled = false;
    case cancel
        openingCancelled = true;
end

end

