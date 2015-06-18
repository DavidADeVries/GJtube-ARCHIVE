function [ ] = updateImageInfo( file, handles)
%updateImageInfo updates the fields within the "Image Information" 

if isempty(file)
    noImage = 'No Image Selected';
    
    filePath = noImage;
    modality = noImage;
    date = noImage;
    sequenceNumber = '0/0';
else    
    filePath = file.dicomInfo.Filename;
    modality = file.dicomInfo.Modality;
    date = file.date.display();
    
    currentPatient = getCurrentPatient(handles);
    sequenceNumber = strcat(num2str(currentPatient.currentFileNum), '/', num2str(currentPatient.getNumFiles()));    
end

set(handles.imagePath, 'String', filePath);
set(handles.modality, 'String', modality);
set(handles.acquisitionDate, 'String', date);
set(handles.imageSequenceNumber, 'String', sequenceNumber);

end

