function [ ] = exportPatients(patients)
%[ ] = exportPatients(patients) interacts with the user to handle the
%exporting of the patient list given

[cancelled, overwrite] = overwriteOrAppendDialog(); %user can choose to overwrite file or append to it

if ~cancelled
    path = strcat('/data/projects/GJtube/testdata/*.csv');
    
    if overwrite
        [exportFilename, exportPathname] = uiputfile(path,'Export Analysis Data');
    else %append
        [exportFilename, exportPathname, ~] = uigetfile({'*.csv','CSV Spreadsheets (*.csv)'},'Export Analysis Data',path);
    end
    
    exportPath = strcat(exportPathname, exportFilename);
    
    if ~isempty(exportPath) %didn't click cancel
        exportToCsv(patients, exportPath, overwrite);
        
        waitfor(exportCompleteDialog());
    end
    
end

end
