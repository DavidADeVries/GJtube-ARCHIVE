classdef MetricPoints
    %MetricPoints stores and performs calculations on the metric points for
    %a given segmented tube
    
    properties
        pylorusPoint = []; %all points to be store as [x, y]
        pointA = [];
        pointB = [];
        pointC = [];
        pointD = [];
    end
    
    methods
        %% Constructor %%
        function metricPoints = MetricPoints(pylorus, pointA, pointB, pointC, pointD)
            metricPoints.pylorusPoint = pylorus;
            metricPoints.pointA = pointA;
            metricPoints.pointB = pointB;
            metricPoints.pointC = pointC;
            metricPoints.pointD = pointD; 
        end
        
        %% getPointCoords %%
        function points = getPointCoords(metricPoints, file)
            points = metricPoints.getPoints();
            
            points = confirmMatchRoi(points, file.roiOn, file.roiCoords);
        end
        
        %% getNumPoints %%
        function numPoints = getNumPoints(metricPoints)
            points = metricPoints.getPoints();
            
            numPoints = height(points);
        end
        
        %% getPoints %%
        function points = getPoints(metricPoints)
            %NOTE: DOES NOT transform for ROI
            %this should only be used locally in the class
            points = [  
                metricPoints.pylorusPoint;...
                metricPoints.pointA;...
                metricPoints.pointB;...
                metricPoints.pointC;...
                metricPoints.pointD];
        end
        
        %% getLabels %%
        function labels = getLabels(metricPoints)
            labels = {'Pylorus', 'A', 'B', 'C', 'D'};
        end
        
        %% getLabelOffsets %%
        function labelOffsets = getLabelOffsets(metricPoints)
            labelOffsets = [5, 3;
                            0, -5;
                            -8, 0;
                            0, 8;
                            0, -5];
        end
    end
    
end

