function [ cancelled ] = confirmRemoveFileDialog( )
%confirmRemoveFileDialog makes sure user really wants to remove the file
%from the patient

cancelled = true;

question = 'Do you wish to permanently remove (cannot be undone!) this file from this patient?';

remove = 'Remove';
cancel = 'Cancel';

default = remove;

choice = questdlg(question, 'Remove File', remove, cancel, default);

switch choice
    case remove
        cancelled = false;
    case cancel
        cancelled = true;
end

end

