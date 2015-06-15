function [ handle ] = patientIdConflictDialog(patientId, firstFilePath, conflictPatientId, conflictFilePath)
%patientIdConflictDialog alerts user during mass file import for patient if
%a file had an expectedly different patient Id than what was seen for the
%first file set for the patient

messageLine1 = char(strcat('The patient ID was determined to be', {' '}, patientId, ' via the first file opened at', {' '}, firstFilePath, '.')); 
messageLine2 = char(strcat('The file at', {' '}, conflictFilePath, {' '}, 'has a patient ID of', {' '}, conflictPatientId, ', which is in conflict, and so this file will be skipped.'));
icon = 'error';
title = 'Patient ID Conflict';

handle = msgbox({messageLine1; messageLine2}, title, icon); %handle used for waiting

end

