function [ transPoints ] = applyRotationMatrix( points, rotMatrix)
%applyRotationMatrix Applies the rotation matrix to the set of points

dims = size(points);

transPoints = zeros(dims);

for i=1:dims(1)
    transPoints(i,:) = (rotMatrix * (points(i,:))')';
end


end

