function [metricPointHandles] = plotMetricPoints(metricPoints, imageDisplayHandle)
%plotMetricPoints plots max/min points in numPoints x 2 array

hold on; %makes sure we stay on the image

dims = size(metricPoints);

for i=1:dims(1)
   impointHandle = impoint(imageDisplayHandle, metricPoints(i,1), metricPoints(i,2));
   setColor(impointHandle, [255,255,0]./255);
   metricPointHandles{i} = impointHandle; 
end

hold off;

end

