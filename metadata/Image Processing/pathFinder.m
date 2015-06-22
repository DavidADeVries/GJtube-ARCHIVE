function [ tubePoints, waypointPassbys ] = pathFinder( image, waypoints, interpolConstrain, priorConstrain, curveConstrain, radius, searchAngle, width, angularRes)
%path_finder for a given image and starting priors, the algorithm segments
%out a tube structure, displaying the results on the given axes handle

numWaypoints = length(waypoints);
dims = size(image);

[~, ~, ~, ft, ~, ~, ~] = phasecong3(double(image));

image = ft;

tubePoints = [];
waypointPassbys = [];

lastPoint = [waypoints(1,1), waypoints(1,2)];
curPoint = [waypoints(2,1), waypoints(2,2)];

curPriorNum = 3; % 1 and 2 have just been used


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

maxIters = 1000;

horizonRes = 0.5;

image = double(image);

while curPriorNum <= numWaypoints && numTubePoints < maxIters
    %pause(0.001);
    vectorAngle = findVectorAngle(lastPoint, curPoint);
    
    interRadius = 1;
    
    curInterpolValue = 0;
    
    for i=-interRadius:interRadius
        for j=-interRadius:interRadius
            curInterpolValue = curInterpolValue + interpolate(image, [curPoint(1)+i, curPoint(2)+j]);
        end
    end
    
    curInterpolValue = curInterpolValue / (2*interRadius + 1).^2;
    
    ang = -searchAngle;
    while ang <= searchAngle
%         [x,y] = findXY(curPoint, vectorAngle + ang, width);
%         horizonPoint = [x,y]; %where the program is looking to.
%         
        %add up all pixel values from curPoint to horizonPoint
        sum = 0;
        
        for i=0:width/horizonRes
            [x,y] = findXY(curPoint, vectorAngle + ang, i*horizonRes);
            
            sum = sum + abs(curInterpolValue - interpolate(image, [x,y]));
        end
        
        interpolValues(((ang+searchAngle)/angularRes)+1) = sum;
        
        % interpol values show difference from current point value to other
        % points. Want least amount of difference as possible to stay in
        % the tube
%         interpolValues(((ang+searchAngle)/angularRes)+1) = abs(curInterpolValue - mean([interpolate(image,interPoint), interpolate(image,closeInterPoint)]));
        
        ang = ang + angularRes;
    end
    
%     figure(1);
%     plot(interpolValues);
%     
%     
%     disp(curInterpolValue);
%     figure(2);
%     plot(abs(interpolValues - curInterpolValue));
%     pause;
        
    [point,correction,priorUsed] = findOptimumPoint2( interpolValues, interpolConstrain, curveConstrain, priorConstrain, curPoint, searchAngle, angularRes, vectorAngle, radius, latestCorrections, waypoints(curPriorNum,:) );
    
    latestCorrections(2:correctionMemory) = latestCorrections(1:correctionMemory-1);
    latestCorrections(1) = correction;
    
    if priorUsed %TODO: this kind of feels like a dirty hack...
        curPriorNum = curPriorNum + 1;

        numPassbys = numPassbys + 1;
        waypointPassbys(numPassbys,:) = point;
    end
    
    
    lastPoint = curPoint;
    curPoint = point;
    
    numTubePoints = numTubePoints + 1;
    tubePoints(numTubePoints,:) = point; % TODO: pre-allocate?!
    
    
    
%     figure(1);
%     plot(point(1),point(2),'.','MarkerSize',10,'MarkerEdgeColor','w');

    
    
    if (curPoint(1) > dims(2) - (width + 1)) || (curPoint(1) < (width + 1) || (curPoint(2) > dims(1) - (width + 1)) || (curPoint(2) < (width + 1)))
        break;
    end
end


end
