classdef DisplayTube
    %DisplayTube holds the handles of a drawn tube
    
    properties
        tubeHandles
        borderHandles
    end
    
    methods
        %% Constructor %%
        function displayTube = DisplayTube(tubePoints, style, lineWidth, borderWidth, borderColour, baseColour)
            % draw the tube
            hold on;
            
            numTubePoints = length(tubePoints);
            
            colorStep = 1/(2*numTubePoints); %used to achieve gradient in tube
            
            switch style
                case 'points' % simply plots the points
                    for i=1:numTubePoints-1
                        localBorderHandles(i) = plot(tubePoints(i,1),tubePoints(i,2),'.','MarkerSize',lineWidth+2*borderWidth,'MarkerEdgeColor', borderColour);
                        localTubeHandles(i) = plot(tubePoints(i,1),tubePoints(i,2),'.','MarkerSize',lineWidth,'MarkerEdgeColor', (0.5+i*colorStep)*baseColour);
                    end
                case 'line' % plots line segments joining all points
                    localBorderHandles = plot(tubePoints(:,1), tubePoints(:,2), '-','lineWidth',lineWidth + 2*borderWidth,'Color', borderColour);
                    
                    for i=1:numTubePoints-1
                        localTubeHandles(i) = plot(tubePoints(i:i+1,1), tubePoints(i:i+1,2), '-','lineWidth',lineWidth,'Color', (0.5+i*colorStep)*baseColour);
                    end
                otherwise
                    warning('Unknown plot type?');
                    localBorderHandles = [];
                    localTubeHandles = [];
            end
            
            hold off;
            
            % store to object
            displayTube.borderHandles = localBorderHandles;
            displayTube.tubeHandles = localTubeHandles;
        end
        
        %% update %%
        function [] = update(displayTube, tubePoints)
            localTubeHandles = displayTube.tubeHandles;
            localBorderHandles = displayTube.borderHandles;
            
            numTubePoints = length(tubePoints);
            
            set(localBorderHandles, 'XData', tubePoints(:,1), 'YData', tubePoints(:,2));
            
            for i=1:numTubePoints-1                
                set(localTubeHandles(i), 'XData', tubePoints(i:i+1,1), 'YData', tubePoints(i:i+1,2));
            end
        end
        
        %% setVisible %%
        function [] = setVisible(displayTube, setting)
            localTubeHandles = displayTube.tubeHandles;
            localBorderHandles = displayTube.borderHandles;
            
            for i=1:length(localTubeHandles)
                set(localTubeHandles(i),'Visible',setting);            
            end
            
            set(localBorderHandles,'Visible',setting);
        end
        
        %% delete %%
        function [] = delete(displayTube)
            localTubeHandles = displayTube.tubeHandles;
            localBorderHandles = displayTube.borderHandles;
            
            for i=1:length(localTubeHandles)
                delete(localTubeHandles(i));            
            end
            
            delete(localBorderHandles);
        end
        
    end
    
end

