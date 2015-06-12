function [ ] = updateTextBorderHandles(leftBorder, rightBorder, topBorder, bottomBorder, tagString, tagPoint)
%updateTextBorderHandles updates the 4 border handles for a piece of
%plotted text

handles = {leftBorder, rightBorder, topBorder, bottomBorder};

for i=1:4 
    set(handles{i},'String',tagString,'Position',tagPoint);
end

applyBorderShifts(leftBorder, rightBorder, topBorder, bottomBorder);

end

