function [ arrowHandle, textHandle] = plotLineWithTag( line, lineWidth, lineColor, arrowEnds)
%plotLineWithTag plots the line struct, using its .tagPoint to put the tag
%in the appropriate place

hold on;

arrowBorderHandle = arrow(line.startPoint, line.endPoint, 'EdgeColor', [0,0,0], 'FaceColor', [0,0,0], 'Width', lineWidth + 2, 'Ends', arrowEnds, 'Length', 11, 'TipAngle', 35);
arrowLineHandle = arrow(line.startPoint, line.endPoint, 'EdgeColor', lineColor, 'FaceColor', lineColor, 'Width', lineWidth, 'Ends', arrowEnds, 'Length', 10, 'TipAngle', 30);

for i=1:4
    handle = text(line.tagPoint(1), line.tagPoint(2), line.tagString, 'Color', [0,0,0], 'FontSize', 13, 'HorizontalAlignment', line.textAlign);
    
    borderHandles{i} = handle;   
end

applyBorderShifts(borderHandles{1}, borderHandles{2}, borderHandles{3}, borderHandles{4});


textColorHandle = text(line.tagPoint(1), line.tagPoint(2), line.tagString, 'Color', lineColor, 'FontSize', 13, 'HorizontalAlignment', line.textAlign);

arrowHandle = struct('arrowLine', arrowLineHandle, 'arrowBorder', arrowBorderHandle);
textHandle = struct('text', textColorHandle, 'leftBorder', borderHandles{1}, 'rightBorder', borderHandles{2}, 'topBorder', borderHandles{3}, 'bottomBorder', borderHandles{4});

hold off;

end

