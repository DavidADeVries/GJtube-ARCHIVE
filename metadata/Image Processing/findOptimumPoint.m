function [ r, c, priorUsed ] = findOptimumPoint( interpolValues, curveConstraint, residualCurve, curPrior, curPoint, searchAngle, angularResolution, vectorAngle, radius )
%find_optimumIndex finds the "best" index in which direction of travel
% will be preferred

%do some adjustments based upon curvature constraints
dims = size(interpolValues);
len = dims(1);

% middle = (len-1)/2;
% 
% for i=1:middle
%     interpolValues(i) = interpolValues(i) + curveConstraint * ((middle + residualCurve) - i);
%     interpolValues(len-i) = interpolValues(len-i) + curveConstraint * ((middle+residualCurve) - i);
% end

% interpolValues(middle + residualCurve) = interpolValues(middle + residualCurve) - 100;
% interpolValues(middle + residualCurve - 1) = interpolValues(middle + residualCurve) - 70;
% interpolValues(middle + residualCurve - 2) = interpolValues(middle + residualCurve) - 50;
% interpolValues(middle + residualCurve + 1) = interpolValues(middle + residualCurve) - 70;
% interpolValues(middle + residualCurve + 2) = interpolValues(middle + residualCurve) - 50;

% figure(2);
% plot(interpolValues);

priorRadius = radius;

distanceFromPrior = sqrt(((curPrior(2) - curPoint(1)).^2) + ((curPrior(1) - curPoint(2)).^2));

if distanceFromPrior < priorRadius
   %optimumAngle = find_vector_angle(curPrior, curPoint);
   r = curPrior(2);
   c = curPrior(1);
   priorUsed = true;
else
    [~,I] = sort(interpolValues);

    optimumAngle = mean(I(1:5))*angularResolution - searchAngle;
    
    [r,c] = find_r_and_c(curPoint, vectorAngle + optimumAngle, radius);
    
    priorUsed = false;
end


end

