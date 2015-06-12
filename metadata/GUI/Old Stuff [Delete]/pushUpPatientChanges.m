function [ handles ] = pushUpPatientChanges( handles, patient, varargin )
%pushUpPatientChanges takes local changes to the current patient and pushes
%them up to the handles level

%first vararg is an override for changes pending
%second vararg is an override for which patient in the patient list to push
%up to (default is handles.currentPatientNum)

if length(varargin) == 1 
    patient.changesPending = varargin{1};
else
    patient.changesPending = true;
end

if length(varargin) == 2
    patientNum = varargin{2};
else
    patientNum = handles.currentPatientNum;
end

handles.patients(patientNum) = patient;

end

