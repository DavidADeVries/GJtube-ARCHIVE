function [ patient ] = getCurrentPatient( handles )
%getCurrentPatient gets the current patient via the handles

if handles.numPatients == 0 % no patients
    patient = Patient.empty;
else
    patient = handles.patients(handles.currentPatientNum);
end

end

