classdef LongitudinalDisplayTube
    %LongitudinalDisplayTube not only contains a display tube, but the
    %metric point handles as well
    
    properties
        displayTube
        metricPointHandles
    end
    
    methods
        %% Constructor %%
        function longitudinalTube = LongitudinalDisplayTube(tubePoints, metricPoints, metricPointColour, draggable, axesHandle, tubeStyle, tubeLineWidth, tubeBorderWidth, tubeBorderColour, tubeBaseColour)
            %draw tube
            longitudinalTube.displayTube = DisplayTube(tubePoints, tubeStyle, tubeLineWidth, tubeBorderWidth, tubeBorderColour, tubeBaseColour);
            
            % draw points
            numMetricPoints = length(metricPoints);
            pointHandles = impoint.empty(numMetricPoints,0);
               
            for i=1:numMetricPoints
                pointHandles(i) = plotImpoint(metricPoints(i,:), metricPointColour, draggable, axesHandle);
            end
                        
            longitudinalTube.metricPointHandles = pointHandles;
        end
        
        %% update %%
        function [] = update(longitudinalTube, tubePoints, metricPoints)
            longitudinalTube.displayTube.update(tubePoints);
            
            pointHandles = longitudinalTube.metricPointHandles;
            
            for i=1:length(pointHandles)
                setPosition(pointHandles(i), metricPoints(i,:));
            end
        end
        
        %% setVisible %%
        function [] = setVisible(longitudinalTube, setting)
            longitudinalTube.displayTube.setVisible(setting);
            
            pointHandles = longitudinalTube.metricPointHandles;
            
            for i=1:length(pointHandles)
                set(pointHandles(i), 'Visible', setting);
            end
        end
        
        %% delete %%
        function [] = delete(longitudinalTube)
            longitudinalTube.displayTube.delete();
            
            pointHandles = longitudinalTube.metricPointHandles;
            
            for i=1:length(pointHandles)
                delete(pointHandles(i));
            end
        end
    end
    
end

