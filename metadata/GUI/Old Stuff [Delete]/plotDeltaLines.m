function [arrowHandles, textHandles] = plotDeltaLines(lines)
%plotDeltaLines plots the lines given in a list of line structs

lineWidth = 3;
lineColor = [255, 103, 0] / 255; %orange
arrowEnds = 'stop'; %double point arrows

hold on; %makes sure we stay on the image

for i=1:length(lines)       
    [arrow, text] = plotLineWithTag(lines(i), lineWidth, lineColor, arrowEnds);
    
    arrowHandles{i} = arrow;
    textHandles{i} = text;
end

hold off;

end

