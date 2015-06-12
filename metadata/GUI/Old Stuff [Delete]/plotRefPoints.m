function [lineHandle] = plotRefPoints( points, imageDisplayHandle )
%plotWaypoints plots waypoints (expects numPoints x 2 matrix)

% dims = size(points);

hold on; %makes sure we stay on the image

% for i=1:dims(1);
%     plot(points(i,1),points(i,2),'x','MarkerSize',10,'MarkerEdgeColor','g');
% end
% 
% if dims(1) > 1
%    plot(points(:,1), points(:,2), '-g','lineWidth',2);
% end

lineHandle = imline(imageDisplayHandle, [points(1,1), points(2,1)], [points(1,2), points(2,2)]);
setColor(lineHandle, [0, 204, 153]/255);

hold off;

end

