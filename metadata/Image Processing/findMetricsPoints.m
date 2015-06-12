function [ maxLeft, min, maxRight ] = findMetricsPoints( tubePoints )
%findMetricsPoints takes tubePoints (that have been corrected by rotating
%such that midline is vertical) and then extracts two maximums and a
%minimum

yVals = tubePoints(:,2);

peakRadius = 10; %peaks may not be this close to one another

[~, minX] = findpeaks(yVals, 'MinPeakDistance', peakRadius);

[~, maxX] = findpeaks(-yVals, 'MinPeakDistance', peakRadius);

maxLeft = tubePoints(maxX(1),:);
maxRight = tubePoints(maxX(2),:);
min = tubePoints(minX(1),:);
    
end

