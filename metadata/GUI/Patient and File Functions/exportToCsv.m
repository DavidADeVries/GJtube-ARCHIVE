function [ ] = exportToCsv(patients, exportPath, overwrite)
%exportToCsv exports the list of patients to the given .csv path.
%'overwrite' specifies whether to overwrite the file completely, or whether
%to append. Note that when appending, only the patients in the file that
%are NOT in the list of patients are saved. If a patient in is the file and
%in the list, the one in the list takes precedent and COMPLETELY overwrites
%the existing patient data

newline = '\n';

lines = cell(0);
    
if ~overwrite
    [fileId, err] = fopen(exportPath, 'r');
    
    if isempty(err)        
        fgets(fileId); %ignore header
        line = fgets(fileId);
        
        ignoreTillNextId = false;
        
        i = 1;
        
        while(ischar(line))
            split = strsplit(line, ',');
            patientId = char(split(1));
            
            if ignoreTillNextId && ~isempty(patientId)
                ignoreTillNextId = false;
            end
            
            if ~ignoreTillNextId && isPatientIdPresent(patientId, patients) %need to be removed, do not save lines
                ignoreTillNextId = true;
            end
            
            if ~ignoreTillNextId
                lines{i} = line;
                i = i + 1;
            end
            
            line = fgets(fileId);
        end
        
        fclose(fileId);
    else
        warning(err);
    end
end
    
[fileId, err] = fopen(exportPath, 'w');

if isempty(err) %write file anew
    %write column headers
    
    headers = { 'Patient Id',...
        'Patient Sex',...
        'Patient DOB (MM/YYYY)',...
        'Sequence Number',...
        'Acquisition Date (MM/DD/YYYY)',...
        'Age at Acquisition (days)',...
        'Modality',...
        'Study Description',...
        'Series Description',...
        'Measurement a (u)',...
        'Measurement b (u)',...
        'Measurement c (u)',...
        'Measurement d (u)',...
        'Measurement e (u)',...
        'Measurement f (u)'};
    
    numHeaders = length(headers);
    
    for i=1:numHeaders
        fprintf(fileId, headers{i});
        
        if i ~= numHeaders
            fprintf(fileId, ',');
        end
    end
    
    fprintf(fileId, newline);
    
    %write data from previous file if choosen to not overwrite
    
    for i=1:length(lines)
        fprintf(fileId, lines{i}); %lines were read in full, with newline characters captured, so just print back out
    end
    
    %write new data from patient list
    
    for i=1:length(patients)
        patient = patients(i);
        patientDOB = Date.empty;
        files = patient.files;
        
        sequenceNumber = 1;
        
        for j=1:length(files)
            file = files(j);
            
            if ~isempty(file.metricPoints) && ~isempty(file.refPoints) && ~isempty(file.midlinePoints) %these fields must be populated for analysis to be considered complete
                if sequenceNumber == 1 %need to write out some patient info for first one
                    patientDOB = Date('19930211');%Date(file.dicomInfo.PatientBirthDate);
                    patientSex = file.dicomInfo.PatientSex;
                    
                    fprintf(fileId, '%s,%s,%s,', patient.patientId, patientSex, patientDOB.display());
                else
                    fprintf(fileId, ',,,'); %don't need to print patient info for every file of the same patient
                end
                                
                ageInDays = file.date.daysSinceYear0() - patientDOB.daysSinceYear0();
                measurements = file.getMeasurements();
                
                fprintf(fileId, '%d,%s,%d,%s,%s,%s,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f,%6.1f',...
                    sequenceNumber,...
                    file.date.display(),...
                    ageInDays,...
                    file.dicomInfo.Modality,...
                    file.dicomInfo.StudyDescription,...
                    file.dicomInfo.SeriesDescription,...
                    measurements.a,...
                    measurements.b,...
                    measurements.c,...
                    measurements.d,...
                    measurements.e,...
                    measurements.f);
                
                fprintf(fileId, newline);
                
                sequenceNumber = sequenceNumber + 1;
            end
        end
    end
    
    fclose(fileId);
    
else
    warning(err);
end

end

function [bool] = isPatientIdPresent(patientId, patients)
    bool = false;
    
    i=1;
    
    while (i <= length(patients) && ~bool)
        if strcmp(patients(i).patientId, patientId)
            bool = true;
        end
        
        i = i+1;
    end
end

