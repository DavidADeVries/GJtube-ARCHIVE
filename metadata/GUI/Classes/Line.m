classdef Line
    %Line consists of a start and end point (in [x,y] format), and the
    %place for a tag (label) and it's string
    
    properties
        startPoint
        endPoint
        tagPoint
        tagStringPrefix = '';
        textAlign %text 'HorizontalAlginment' property value 'left', 'center', or 'right'
        isBridge = false; % a bridge is a line used to not show a measurement, but to be a reference line for another line that does display a measurement
    end
    
    methods
        %% Constructor %%
        function line = Line(varargin) %params: (startPoint, endPoint, tagPoint, textAlign, isBridge*, tagString*)
            if length(varargin) >= 4
                line.startPoint = varargin{1};
                line.endPoint = varargin{2};
                line.tagPoint = varargin{3};
                line.textAlign = varargin{4};
            end
            
            if length(varargin) >= 5
                line.isBridge = varargin{5};
            end
            
            if length(varargin) >= 6
                line.tagStringPrefix = varargin{6};
            end
        end
        
        %% getHalfwayPoint %%
        function [ halfwayPoint ] = getHalfwayPoint(line) %getHalfwayPoint returns the point halfway between the two points
            
            halfwayPoint = getHalfwayPoint(line.startPoint, line.endPoint);
                        
        end
        
        %% length %%
        function [ length ] = getLength( line, unitConversion )
            %lineLength return the length of a Line
            
            diff = line.startPoint - line.endPoint;
            
            diff(1) = diff(1) * unitConversion(1);
            diff(2) = diff(2) * unitConversion(2);
            
            length = norm(diff); 
        end
        
        %% getTagString %%
        function [ tagString] = getTagString( line, unitString, unitConversion)
            %getTagString gives a string that may be uses to tag the line given
            
            if ~isempty(unitString) && ~line.isBridge
                convertedLength = line.getLength(unitConversion);
                
                roundedLength = round(10*convertedLength) / 10; % round to one decimal place
                
                tagString = [line.tagStringPrefix, num2str(roundedLength), unitString];
                
                %tagString = ['\bf', tagString]; %bold if desired
            else
                tagString = '';
            end
            
        end

    end
    
end

