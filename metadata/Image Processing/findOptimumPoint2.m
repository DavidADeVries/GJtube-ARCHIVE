function [ point, correctionAngle, priorUsed ] = findOptimumPoint2( interpolValues, interpolConstrain, curveConstrain, priorConstrain, curPoint, searchAngle, angularResolution, vectorAngle, radius, latestCorrections, curPrior )
%find_optimumIndex finds the "best" index in which direction of travel
% will be preferred

toDeg = 180/pi();
toRad = pi()/180; 

priorUsed = false;

% get set of values for each angle that reflect maintaining a similar
% curvature

average = circ_mean(latestCorrections.*toRad).*toDeg;

curveValues = zeros(size(interpolValues));

for i=1:length(interpolValues)
    angle = i*angularResolution - searchAngle;
    curveValues(i) = abs((average - angle).^2);
end

% get set of values for each angle that reflect trying to get towards the
% next prior point

distanceFromPrior = sqrt(((curPrior(1) - curPoint(1)).^2) + ((curPrior(2) - curPoint(2)).^2));

angleToPrior = findVectorAngle(curPoint, curPrior);


priorValues = ones(size(interpolValues));

if ((vectorAngle + searchAngle) > angleToPrior && (vectorAngle - searchAngle) < angleToPrior)
    for i=1:length(interpolValues)
        angle = vectorAngle + (i*angularResolution - searchAngle);
        
        priorValues(i) = abs((angleToPrior - angle).^2) + 1 * distanceFromPrior^2;
    end
end

if distanceFromPrior < 2*radius
   priorUsed = true; 
end


%normalize
priorValues = priorValues ./ checkZero(max(priorValues));
interpolValues = interpolValues ./ checkZero(max(interpolValues));
curveValues = curveValues ./ checkZero(max(curveValues));

% combine all three value sets to get the final set of values for each
% angle with which a final decision of what direction to head will be made


decisionValues = (interpolConstrain.*interpolValues) + (curveConstrain.*curveValues) + (priorConstrain.*priorValues);


[~,I] = sort(decisionValues);

correctionAngle = mod(mean(I(1:5))*angularResolution - searchAngle,  360);

    
[x,y] = findXY(curPoint, vectorAngle + correctionAngle, radius);

point = [x,y];

end

