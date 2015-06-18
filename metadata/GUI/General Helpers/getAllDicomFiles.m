function [ fileList ] = getAllDicomFiles(folderPath)
%getAllFiles returns a list of filepaths to all files with the given
%directory and all subdirectories

dirList = dir(folderPath);

fileList = cell(0);

for i=1:length(dirList)
    entry = dirList(i);
    name = entry.name;
    
    if entry.isdir %recurse through directories
        if ~(strcmp(name, '..') || strcmp(name, '.')) %let's no recurse through the entire file structure :)
            fileList = [fileList, getAllDicomFiles(strcat(folderPath, '/', name))];
        end
    else %add files (non-dir entries)
        len = length(name);
        
        if strcmp(name(len-2 : len), 'dcm') %make sure only dicom files are sucked up
            fileList{length(fileList)+1} = strcat(folderPath, '/', entry.name);
        end
    end
    
end


end

