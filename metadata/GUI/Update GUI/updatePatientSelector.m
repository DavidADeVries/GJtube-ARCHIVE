function [ ] = updatePatientSelector( handles )
%updatePatientSelector updates options for available patients to select
%from

patients = handles.patients;

numPatients = handles.numPatients;

if numPatients == 0 %if no patients are open
    set(handles.patientSelector, 'String', {'No Patient Selected'}, 'Value', 1);
else
    for i=1:length(patients)
        selectorOptions{i} = num2str(patients(i).patientId);
    end
    
    set(handles.patientSelector, 'String', selectorOptions);
    set(handles.patientSelector, 'Value', handles.currentPatientNum);
end


end

