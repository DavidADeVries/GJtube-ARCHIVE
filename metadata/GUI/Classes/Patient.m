classdef Patient
    %Patient a patient contains a list of (DICOM) Files, in order from
    %earliest to latest
    
    properties
        files = File.empty;
        currentFileNum = 0;
        patientId
        savePath = '';
        changesPending = true;
        longitudinalFileNumbers = []; %all file numbers valid for longitudinal compare. On/off is set in File.
        longitudinalOn = false;
    end
    
    methods
        %% Constructor %%
        function patient = Patient(patientId)
            patient.patientId = patientId;
        end
        
        
        %% getCurrentFile %%
        function file = getCurrentFile(patient)
            if patient.currentFileNum == 0 %no files
                file = File.empty;
            else
                file = patient.files(patient.currentFileNum);
            end
        end
        
        %% updateCurrentFile %%
        function patient = updateCurrentFile(patient, file) %updates the current file to be the file provided
            patient.files(patient.currentFileNum) = file;
        end
        
        %% addFile %%
        function patient = addFile(patient, file)            
            oldFiles = patient.files;
            numOldFiles = length(oldFiles);            
            
            i = 1; %needs to be defined before hand, in case numOldFiles = 0;
            
            while i <= numOldFiles
                if file.date < oldFiles(i).date
                    break;
                end
                
                i = i+1;
            end
                      
            if i == 1
                newFiles = [file, oldFiles];                     
                patient.currentFileNum = 1;
            elseif i == numOldFiles
                newFiles = [oldFiles, file];                                 
                patient.currentFileNum = numOldFiles+1;
            else            
                newFiles = [oldFiles(1:i-1), file, oldFiles(i:numOldFiles)];
                patient.currentFileNum = i;
            end
                        
            patient.files = newFiles;   
        end
        
        %% getNumFiles %%
        function numFiles = getNumFiles(patient)
            numFiles = length(patient.files);
        end
        
        %% updateLongitudinalFileNumber %%
        function patient = updateLongitudinalFileNumbers(patient) % checks file list to see if any others should be added on as an option, or if any should be removed (if they're no longer valid: no tube, no metric points, etc)
            patientFiles = patient.files;
            fileNumbersCounter = 1;

            for i=1:length(patientFiles)
                if patientFiles(i).isValidForLongitudinal()
                    fileNumbers(fileNumbersCounter) = i;
                    fileNumbersCounter = fileNumbersCounter + 1;
                end
            end
            
            patient.longitudinalFileNumbers = fileNumbers;
        end
        
        %% getLonditudinalDisplayFileNumbers %%
        function displayFileNumbers = getLongitudinalDisplayFileNumbers(patient) %gives the file numbers from the longitudinalFileNumber list that have their display option on
            allFileNumbers = patient.longitudinalFileNumbers;
            
            allFileCounter = 1;
            
            displayFileNumbers = [];
            
            for i=1:length(allFileNumbers)
                if patient.files(allFileNumbers(i)).longitudinalOverlayOn
                    displayFileNumbers(allFileCounter) = allFileNumbers(i);
                    allFileCounter = allFileCounter + 1;
                end
            end
        end
        
        %% getLongitudinalListboxData %%
        function [ labels, values ] = getLongitudinalListboxData(patient)
            %getLongitudinalListboxData returns the labels for the listbox as well as
            %which are selected
            
            valuesCounter = 1;
            
            longitudinalFileNums = patient.longitudinalFileNumbers;
            patientFiles = patient.files;
            
            for i=1:length(longitudinalFileNums)
                if patientFiles(longitudinalFileNums(i)).longitudinalOverlayOn
                    values(valuesCounter) = i;
                    valuesCounter = valuesCounter + 1;
                end
                
                labels{i} = patientFiles(longitudinalFileNums(i)).date.display(); %labels are date of image
            end           
        end
        
        %% removeCurrentFile %%
        function patient = removeCurrentFile(patient) %removes current file, new current file is later image (earlier if latest image is removed)
            oldFiles = patient.files;
            numOldFiles = length(oldFiles);
            
            numNewFiles = numOldFiles - 1;
            
            currentFileNumber = patient.currentFileNum;
            
            if numNewFiles == 0
                patient.currentFileNum = 0;
                patient.files = [];
            else
                newFileCounter = 1;
                newFiles = File.empty(numNewFiles, 0);
                
                for i=1:numOldFiles
                    if i ~= currentFileNumber
                        newFiles(newFileCounter) = oldFiles(i);
                        newFileCounter = newFileCounter + 1;
                    end
                end
                
                patient.files = newFiles;
                
                if currentFileNumber > numNewFiles
                    currentFileNumber = numNewFiles; 
                end
                
                patient.currentFileNum = currentFileNumber;
            end            
        end
        
        %% updateFile %%
        function [ patient ] = updateFile( patient, file, updateUndo, changesPending, varargin)
            %pushUpChanges updates current file changes for a patient
            
            if updateUndo
                file = file.updateUndoCache();
            end
            
            if length(varargin) == 1 %fileNumber is specified! Not currentFile
                fileNum = varargin{1};
                patient.files(fileNum) = file;
            else
                patient = patient.updateCurrentFile(file);
            end
            
            if changesPending
                patient.changesPending = true;
            end
            
        end

        %% saveToDisk %%
        function [ patient ] = saveToDisk(patient)
            %saveToDisk saves the patient's data and open files to the disk
            if isempty(patient.savePath)
                filename = strcat('Tube Analysis', {' '}, num2str(patient.patientId), '.mat');
                path = strcat('/data/projects/GJtube/rawdata/', filename);
                
                [saveFilename, savePathname] = uiputfile(path,'Save Patient');
                
                if saveFilename ~= 0
                    patient.savePath = strcat(savePathname, saveFilename);
                    
                    fid = fopen(patient.savePath, 'w'); %create file
                    fclose(fid);
                end
            end
            
            if ~isempty(patient.savePath) %if not empty, save, otherwise abort
                patient.changesPending = false; % because they're being saved now :)
                
                save(patient.savePath, 'patient');
            end
        end
    end
    
end

