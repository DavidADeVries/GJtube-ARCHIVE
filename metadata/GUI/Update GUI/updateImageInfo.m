function [ ] = updateImageInfo( file, handles)
%updateImageInfo updates the fields within the "Image Information" 

if isempty(file)
    noImage = 'No Image Selected';
    
    filePath = noImage;
    modality = noImage;
    date = noImage;
else
    filePath = file.dicomInfo.Filename;
    modality = file.dicomInfo.Modality;
    date = file.date.display();
end

set(handles.imagePath, 'String', filePath);
set(handles.modality, 'String', modality);
set(handles.acquisitionDate, 'String', date);

end

