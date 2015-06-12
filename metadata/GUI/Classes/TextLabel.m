classdef TextLabel
    %TextLabel a class that holds the handles for a text label
    
    properties
        mainText
        leftBorder
        rightBorder
        topBorder
        bottomBorder
    end
    
    methods
        %% Constructor %%
        function textLabel = TextLabel(line, unitString, unitConversion, borderColour, fontColour, fontSize)
            tagString = line.getTagString(unitString, unitConversion);
            
            borderHandles = cell(4,1);
            
            % hold on;
            
            for i=1:4
                handle = text(line.tagPoint(1), line.tagPoint(2), tagString, 'Color', borderColour, 'FontSize', fontSize, 'HorizontalAlignment', line.textAlign);
                
                borderHandles{i} = handle;
            end
            
            applyBorderShifts(borderHandles);
                        
            textLabel.mainText = text(line.tagPoint(1), line.tagPoint(2), tagString, 'Color', fontColour, 'FontSize', fontSize, 'HorizontalAlignment', line.textAlign);
            
            textLabel.leftBorder = borderHandles{1};
            textLabel.rightBorder = borderHandles{2};
            textLabel.topBorder = borderHandles{3};
            textLabel.bottomBorder = borderHandles{4};
            
            % hold off;
        end
        
        
        %% update %%
        function [] = update(textLabel, line, unitString, unitConversion)
            tagString = line.getTagString(unitString, unitConversion);
            
            set(textLabel.mainText,'String',tagString,'Position',line.tagPoint);
            
            handles = {textLabel.leftBorder, textLabel.rightBorder, textLabel.topBorder, textLabel.bottomBorder};
                        
            for i=1:4
                set(handles{i}, 'String', tagString, 'Position', line.tagPoint);                
            end
            
            applyBorderShifts(handles);
        end
        
        %% setVisible %%
        
        function [] = setVisible(textLabel, setting) %sets all handles 'Visible' field. setting is 'on' or 'off'
            set(textLabel.mainText, 'Visible', setting);
            set(textLabel.leftBorder, 'Visible', setting);
            set(textLabel.rightBorder, 'Visible', setting);
            set(textLabel.topBorder, 'Visible', setting);
            set(textLabel.bottomBorder, 'Visible', setting);
        end
        
        %% delete %%
        
        function [] = delete(textLabel)
            delete(textLabel.mainText);
            delete(textLabel.leftBorder);
            delete(textLabel.rightBorder);
            delete(textLabel.topBorder);
            delete(textLabel.bottomBorder);
        end
        
    end
    
end

