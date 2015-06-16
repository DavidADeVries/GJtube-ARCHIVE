function [ cancelled, overwrite ] = overwriteOrAppendDialog()
%overwriteOrAppendDialog asks user if they want overwrite the file or
%append to it. They can also cancel if need be

cancelled = false;
overwrite = true;

question = 'Do you wish to create a new file or append to a previous file? If "Append" is chosen and a patient is in both the existing file and being exported, the existing patient data will be replaced entirely by the data from the patient in the export.';

overwriteOption = 'Overwrite';
append = 'Append';
cancel = 'Cancel';

default = append;

choice = questdlg(question, 'Overwrite or Append', overwriteOption, append, cancel, default);

switch choice
    case append
        overwrite = false;
    case overwriteOption
        overwrite = true;
    case cancel
        cancelled = true;
end

end

