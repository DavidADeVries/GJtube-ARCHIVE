function [arrowHandles, textHandles] = plotMetricLines(lines)
%plotMetricLines plots the lines given in a list of line structs

lineWidth = 3;
lineColor = [0, 255, 0] / 255; %lime green. aw yeah.
arrowEnds = 'both'; %double point arrows

hold on; %makes sure we stay on the image

for i=1:length(lines)
    
    [arrow, text] = plotLineWithTag(lines(i), lineWidth, lineColor, arrowEnds);
    
    arrowHandles{i} = arrow;
    textHandles{i} = text;
end

hold off;

end

