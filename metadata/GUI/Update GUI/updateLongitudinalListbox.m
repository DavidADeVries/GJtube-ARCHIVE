function [ ] = updateLongitudinalListbox(currentPatient, handles)
%updateLongitudinalListbox updates entries in the longitudinal comparison
%listbox

if isempty(currentPatient)
    listboxLabels = '';
    listboxValues = [];
else
    [listboxLabels, listboxValues] = currentPatient.getLongitudinalListboxData();
end

set(handles.longitudinalListbox, 'String', listboxLabels, 'Value', listboxValues);

end

