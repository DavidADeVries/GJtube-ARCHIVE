function [lineHandle] = plotQuickMeasurePoints( line, imageDisplayHandle )
%plotWaypoints plots waypoints (expects numPoints x 2 matrix)

% dims = size(points);

hold on; %makes sure we stay on the image

% for i=1:dims(1);
%     plot(points(i,1),points(i,2),'x','MarkerSize',10,'MarkerEdgeColor','r');
% end
% 
% if dims(1) > 1
%    plot(points(:,1), points(:,2), '-r','lineWidth',2);
% end

lineHandle = imline(imageDisplayHandle, [line.startPoint(1), line.endPoint(1)], [line.startPoint(2), line.endPoint(2)]);

color = [255, 153, 51]/255;

setColor(lineHandle, color);

for i=1:4
    handle = text(line.tagPoint(1), line.tagPoint(2), line.tagString, 'Color', [0,0,0], 'FontSize', 13, 'HorizontalAlignment', line.textAlign);
    
    borderHandles{i} = handle;   
end

applyBorderShifts(borderHandles{1}, borderHandles{2}, borderHandles{3}, borderHandles{4});


textColorHandle = text(line.tagPoint(1), line.tagPoint(2), line.tagString, 'Color', color, 'FontSize', 13, 'HorizontalAlignment', line.textAlign);

lineHandle = struct('line',lineHandle,'text', textColorHandle, 'leftBorder', borderHandles{1}, 'rightBorder', borderHandles{2}, 'topBorder', borderHandles{3}, 'bottomBorder', borderHandles{4});

hold off;

end

