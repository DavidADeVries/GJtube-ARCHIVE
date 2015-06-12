function [ handles ] = removeCurrentPatient( handles )
%removeCurrentPatient removes the current patient from the patient list.
%Updates currentPatientNum accordingly

newPatients = Patient.empty(handles.numPatients-1,0);

newCounter = 1;

patientNum = handles.currentPatientNum;

for i=1:handles.numPatients
    if i ~= patientNum
        newPatients(newCounter) = handles.patients(i); %shift all down to fill gap
        
        newCounter = newCounter + 1;
    end
end

handles.patients = newPatients;

handles.numPatients = handles.numPatients - 1; %reduce the number of patients

if handles.currentPatientNum > handles.numPatients
    handles.currentPatientNum = handles.numPatients;
end

end

