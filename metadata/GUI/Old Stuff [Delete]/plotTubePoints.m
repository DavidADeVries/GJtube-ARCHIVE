function [ ] = plotTubePoints( tubePoints, style, baseColor)
%plotTubePoints plots the given points. Assumes axes are already set up

hold on;

numTubePoints = length(tubePoints);

colorStep = 1/(2*numTubePoints);

switch style
    case 'points' % simply plots the points
        for i=1:numTubePoints-1
            plot(tubePoints(i,1),tubePoints(i,2),'.','MarkerSize',8,'MarkerEdgeColor', (0.5+i*colorStep)*baseColor);
        end
    case 'line' % plots line segments joining all points
        for i=1:numTubePoints-1
            plot(tubePoints(i:i+1,1), tubePoints(i:i+1,2), '-','lineWidth',7,'Color', [0,0,0]);
            plot(tubePoints(i:i+1,1), tubePoints(i:i+1,2), '-','lineWidth',5,'Color', (0.5+i*colorStep)*baseColor);
        end
    otherwise
        warning('Unknown plot type?');
end


hold off;
        
end

