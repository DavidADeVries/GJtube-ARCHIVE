function [ patientNum, patient ] = findPatient( patients, patientId)
%findPatient returns the patient and corresponding index that matches the
%given patient ID

patient = Patient.empty;
patientNum = 0;

i = 1;

while patientNum == 0 && i <= length(patients)
   if patients(i).patientId == patientId
       patient = patients(i);
       patientNum = i;
   end
   
   i = i+1;
end


end

