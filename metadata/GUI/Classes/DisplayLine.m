classdef DisplayLine
    %displayLine stores line handle as well the border line handle
    
    properties
        lineHandle
        borderHandle
    end
    
    methods
        %% Constructor %%
        function displayLine = DisplayLine(line, borderColour, lineColour, lineWidth, arrowEnds)
            borderWidth = Constants.DISPLAY_LINE_BORDER_WIDTH;
            
            displayLine.borderHandle = arrow(line.startPoint, line.endPoint, 'EdgeColor', borderColour, 'FaceColor', borderColour, 'Width', lineWidth + 2*borderWidth, 'Ends', arrowEnds, 'Length', 11, 'TipAngle', 35);
            displayLine.lineHandle = arrow(line.startPoint, line.endPoint, 'EdgeColor', lineColour, 'FaceColor', lineColour, 'Width', lineWidth, 'Ends', arrowEnds, 'Length', 10, 'TipAngle', 30);
        end
        
        %% update %%
        function [] = update(displayLine, line)
            arrow(displayLine.lineHandle, 'Start', line.startPoint, 'Stop', line.endPoint);
    
            arrow(displayLine.borderHandle, 'Start', line.startPoint, 'Stop', line.endPoint);
        end
        
        %% setVisible %%
        function [] = setVisible(displayLine, setting)
            set(displayLine.lineHandle, 'Visible', setting);
            set(displayLine.borderHandle, 'Visible', setting);
        end
               
        %% delete %%
        function [] = delete(displayLine)
            delete(displayLine.lineHandle);
            delete(displayLine.borderHandle);
        end
        
        %% bringToTop %%
        function [] = bringToTop(displayLine)
            set(displayLine.borderHandle, 'Layer', 'top');
            set(displayLine.lineHandle, 'Layer', 'top'); %want border behind line, so bring up line last
        end
    end
    
end

