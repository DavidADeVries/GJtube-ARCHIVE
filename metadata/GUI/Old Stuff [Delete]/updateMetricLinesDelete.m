function [ ] = updateMetricLines(lines, arrowHandles, textHandles)
%updateMetricLines used by callback functions to update GUI plot of lines
%using the handles from their original creation

for i=1:length(lines)
        
    set(textHandles{i}.text,'String',lines(i).tagString,'Position',lines(i).tagPoint);
    
    updateTextBorderHandles(textHandles{i}.leftBorder, textHandles{i}.rightBorder, textHandles{i}.topBorder, textHandles{i}.bottomBorder, lines(i).tagString, lines(i).tagPoint);
    
    arrow(arrowHandles{i}.arrowLine,'Start',lines(i).startPoint,'Stop',lines(i).endPoint);
    
    arrow(arrowHandles{i}.arrowBorder,'Start',lines(i).startPoint,'Stop',lines(i).endPoint);
end

end

