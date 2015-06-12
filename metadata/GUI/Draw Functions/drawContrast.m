function [ handles ] = drawContrast(currentFile, handles )
%drawContrast just does the contrast
    
cLim = currentFile.getCurrentLimits(); %contrast limits

set(handles.imageAxes, 'CLim', cLim);

end

