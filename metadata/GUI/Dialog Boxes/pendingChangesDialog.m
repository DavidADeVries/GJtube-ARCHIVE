function [ cancelled, saveChanges ] = pendingChangesDialog( )
%pendingChangesDialog asks user if they want to save changes. User can
%choose yes or no, or cancel the closing

cancelled = false;
saveChanges = true;

question = 'Do wish to save pending changes before closing?';

save = 'Save';
discard = 'Discard';
cancel = 'Cancel';

default = discard;

choice = questdlg(question, 'Pending Changes', save, discard, cancel, default);

switch choice
    case save
        saveChanges = true;
    case discard
        saveChanges = false;
    case cancel
        cancelled = true;
end

end

