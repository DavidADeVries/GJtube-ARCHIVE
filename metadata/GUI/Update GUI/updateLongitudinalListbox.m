function [ ] = updateLongitudinalListbox(currentPatient, handles)
%updateLongitudinalListbox updates entries in the longitudinal comparison
%listbox

[listboxLabels, listboxValues] = currentPatient.getLongitudinalListboxData();

set(handles.longitudinalListbox, 'String', listboxLabels, 'Value', listboxValues);

end

