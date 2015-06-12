function [ handles ] = updatePatient( patient, handles, varargin)
%updatePatient updates version of patient in the handles patient list
%optional 3rd parameter of which patient number to update to. Default is
%handles.currentPatientNum

if length(varargin) == 1 % patient num specified
    patientNum = varargin{1};
else
    patientNum = handles.currentPatientNum;
end

handles.patients(patientNum) = patient;

end

