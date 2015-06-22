function [ tubePoints, waypointPassbys ] = pathFinder2( image, waypoints, interpolConstrain, priorConstrain, curveConstrain, radius, searchAngle, width, angularRes)
%path_finder for a given image and starting priors, the algorithm segments
%out a tube structure, displaying the results on the given axes handle

numWaypoints = length(waypoints);
dims = size(image);

normalized = zeros(dims);

imMax = double(max(max(image)));
imMin = double(min(min(image)));

for i=1:dims(1)
    for j=1:dims(2)
        normalized(i,j) = (double(image(i,j)) - imMin) / (imMax-imMin);
    end
end

tubePoints = [];
waypointPassbys = [];

firstPoint = [waypoints(1,1), waypoints(1,2)];

angRes = 1;

% find the horizontal


lastPoint = [waypoints(1,1), waypoints(1,2)];
curPoint = [waypoints(2,1), waypoints(2,2)];

%edges = edge(normalized,'Canny',[0.05,0.3]);%edge(image,'sobel',0.0015);

[~, ~, ~, ft, ~, ~, ~] = phasecong3(double(image));

imBw = im2bw(ft, graythresh(ft));

cleaned = cleanupImage(imBw,7);

edges = cleaned;

curWaypointNum = 3; % 1 and 2 have just been used


%width = 12; %number of pixels that specifies the general witdth of the tube. This gives the sweep radius of where it looks to find the next step
%angularRes = 1; %for the sweep, the resolution at which angle to search at

%searchAngle = 75; %stops curve from taking crazy turns.


%radius = 3; %the length of the jump

interpolValues = zeros(((searchAngle * 2)/angularRes)+1,1);

%figure(1);
%imshow(image,[]);

% axes(handles.imageDisplay);
% hold on;

%pause;

correctionMemory = 20;
latestCorrections = zeros(correctionMemory,1);

numTubePoints = 0;
numPassbys = 0;

maxIters = 500;

tubeWidth = 0;

horzScanRadius = 5;
vertScanRadius = 10;

stepRadius = 1;
waypointRadius = 3;

% figure(1);
% imshow(edges,[]);
% hold on;
% 
% plot(curPoint(1),curPoint(2),'Marker','o','MarkerEdgeColor','c');
% plot(lastPoint(1),lastPoint(2),'Marker','o','MarkerEdgeColor','c');

while curWaypointNum <= numWaypoints && numTubePoints < maxIters
    
    run = curPoint(1) - lastPoint(1);
    rise = curPoint(2) - lastPoint(2);
    
    stepVector = [run, rise];
    
    stepVector = stepRadius*(stepVector / norm(stepVector));
    
    nextPoint = [curPoint(1) + stepVector(1), curPoint(2) + stepVector(2)];
        
    if norm(nextPoint - waypoints(curWaypointNum,:)) < waypointRadius
        nextPoint = waypoints(curWaypointNum,:);
        curWaypointNum = curWaypointNum + 1;
    else
        %     disp('Next:');
        %     disp(nextPoint);
        %
%             plot(nextPoint(1),nextPoint(2),'Marker','o','MarkerEdgeColor','yellow');
        
        angle = atand(rise/run); %rotate line form curPoint to nextPoint to horizontal
        
        %     disp('Angle');
        %     disp(angle);
        
        shift = [0,0]; %no shifting
        angleShift = -nextPoint; %nextPoint is centre of rotation
        scale = 1; %no scaling
        
        transform = getTransform(shift,scale,angleShift,angle);
        
        scanValues = zeros(2*vertScanRadius+1, 2*horzScanRadius+1);
        
        for i=1:2*vertScanRadius+1
            for j=1:2*horzScanRadius+1
                interPoint = [nextPoint(1) + 2*(j-horzScanRadius-1), nextPoint(2) + 2*(i-vertScanRadius-1)];
                
                %             disp('POINT:')
                %             disp(interPoint);
                
                [x,y] = transformPointsForward(transform, interPoint(1), interPoint(2)); %rotate to be parallel with line
                interPoint = [x,y];
                
                %             disp(interPoint);
                
%                 plot(interPoint(1),interPoint(2),'Marker','x','MarkerEdgeColor','white');
                
                scanValues(i,j) = interpolate(edges, interPoint);
            end
        end
        
        rowValues = sum(scanValues,2); %sum across rows
        
%         topMax = 0;
%         topIndex = 0;
%         
%         bottomMax = 0;
%         bottomIndex = 0;
%         
%         middle = vertScanRadius + 1;
%         
%         for i=1:vertScanRadius
%             if rowValues(middle+i) > topMax
%                 topMax = rowValues(middle+i);
%                 topIndex = +i;
%             end
%             
%             if rowValues(middle-i) > bottomMax
%                 bottomMax = rowValues(middle-i);
%                 bottomIndex = -i;
%             end
%         end
%         
%         middleIndex = (topIndex + bottomIndex)/2;

        minVal = Inf;
        minIndices = [];
        minIndex = 1;
        
        for i=1:vertScanRadius*2+1
            if rowValues(i) < minVal
                minVal = rowValues(i);
                minIndices = [i];
                minIndex = 2;
            elseif rowValues(i) == minVal
                minIndices(minIndex) = i;
                minIndex = minIndex + 1;
            end
        end
        
        middleIndex = mean(minIndices) - (vertScanRadius + 1);
        
        %     disp('Index');
        %     disp(middleIndex);
        
        nextPoint = [nextPoint(1), nextPoint(2) + 2*middleIndex];
        [x,y] = transformPointsForward(transform, nextPoint(1), nextPoint(2));
        nextPoint = [x,y];
    end
    
%     plot(nextPoint(1),nextPoint(2),'Marker','o','MarkerEdgeColor','red');
    
    %store
    lastPoint = curPoint;
    curPoint = nextPoint;
    
    numTubePoints = numTubePoints + 1;
    tubePoints(numTubePoints,:) = nextPoint; % TODO: pre-allocate?!
    
%     pause;

    if nextPoint(1) < 10 || nextPoint(1) > dims(1) - 10 || nextPoint(2) < 10 || nextPoint(2) > dims(2) + 10
        break;
    end
end

% hold off;

end
