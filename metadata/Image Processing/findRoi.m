function [ xmin,ymin,width,height ] = findRoi( image )
%findRoi Given an image, uses edge detection to find a reasonable ROI

edgeMap = edge(image, 'Sobel');

dims = size(edgeMap);

xmin = dims(1);
ymin = dims(1);
xmax = 0;
ymax = 0;



for x=1:dims(2)
    for y=1:dims(1)
        if edgeMap(y,x) == 1
           if y < ymin
               ymin = y;
           end
           
           if y > ymax
               ymax = y;
           end
           
           if x < xmin
               xmin = x;
           end
           
           if x > xmax
               xmax = x;
           end
        end
    end
end

width = xmax - xmin;
height = ymax - ymin;

end

