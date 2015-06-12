function [transform] = getTransform(shift, scale, angleShift, angle)
%getTransform takes the transform parameters and creates an affine2d class
%transformation to represent it

%need to transform into bottom point as centre of rotation coords
centreShiftMatrix = eye(3);
centreShiftMatrix(3,1) = -angleShift(1);
centreShiftMatrix(3,2) = -angleShift(2);

invCentreShiftMatrix = eye(3);
invCentreShiftMatrix(3,1) = angleShift(1);
invCentreShiftMatrix(3,2) = angleShift(2);

%shift matrix
shiftMatrix = eye(3);
shiftMatrix(3,1) = shift(1);
shiftMatrix(3,2) = shift(2);

%scaling matrix
scaleMatrix = eye(3);
scaleMatrix(1,1) = scale;
scaleMatrix(2,2) = scale;

scaleMatrix = invCentreShiftMatrix * scaleMatrix * centreShiftMatrix;

%rotation matrix

rotationMatrix = [cosd(angle) sind(angle) 0; -sind(angle) cosd(angle) 0; 0 0 1];

rotationMatrix = (invCentreShiftMatrix)*rotationMatrix*centreShiftMatrix;

%apply all transforms

transMatrix = scaleMatrix*rotationMatrix*shiftMatrix;

transform = affine2d(transMatrix);


end

